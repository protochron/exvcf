defmodule ExVcf.Vcf.Alt do
  alias ExVcf.Vcf.Alt
  alias ExVcf.Vcf.HeaderLine


  #  DEL Deletion relative to the reference
  #• INS Insertion of novel sequence relative to the reference
  #• DUP Region of elevated copy number relative to the reference
  #2
  #• INV Inversion of reference sequence
  #• CNV Copy number variable region (may be both deletion and duplication)
  #The CNV category should not be used when a more specific category can be applied. Reserved subtypes include: • DUP:TANDEM Tandem duplication
  #• DEL:ME Deletion of mobile element relative to the reference
  #• INS:ME Insertion of a mobile element relative to the reference
  @header_type "ALT"
  def type, do: @header_type

end
