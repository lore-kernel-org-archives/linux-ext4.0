From: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
Subject: trying to understand ext4 extents on disk format
Date: Thu, 29 Jul 2010 15:05:02 +0200 (CEST)
Message-ID: <Pine.A41.4.64.1007291431530.651280@stalin.acc.umu.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.acc.umu.se ([130.239.18.156]:53358 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab0G2NPI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jul 2010 09:15:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by amavisd-new (Postfix) with ESMTP id EC11B58B
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jul 2010 15:05:06 +0200 (MEST)
Received: from stalin.acc.umu.se (stalin.acc.umu.se [130.239.18.135])
	by mail.acc.umu.se (Postfix) with ESMTP id E4936588
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jul 2010 15:05:02 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by stalin.acc.umu.se (Postfix) with ESMTP id B04912C
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jul 2010 15:05:02 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

I am implementing support for ext4 extents in the Windows driver "Ext2Fsd" 
originally written by Matt Wu (http://www.ext2fsd.com/) the driver 
implements full read/write support for ext2/ext3 and is considered stable 
by many users.

To understand the ext4 extents format on disk I have read a few papers by 
Theodore Ts'o and studied a program called Ext2Read 
(http://ext2read.blogspot.com/) but I am a bit unsure how to find all 
extents when there are more than one block of them so the index has more 
than one entry, if I understand it correctly the root is a single entry 
that points to a block of indexes and the indexes points to different 
blocks of extent entrys and they are all in increasing logical block 
number order.

The full function is included below but here is the lines I am unsure 
about, I want to find the block of indexes or extents to continue 
searching in:
     for (i = 0; i < eh->eh_entries; i++, ei++) {
         if(Index >= ei->ei_block) {
             /* read next block with index or entrys */
             /* call this funtion recursivley on the next block */
         }
     }

It would be helpfull if anyone that understands extents better that me 
commented this.

Bo Branten

The full funtion:

/* translate logical block number to physical block numer, Index is lbn, 
Block is pbn, Number is number of contiguous pb, Alloc is extending the 
file (not implemented for ext4 extents yet) The other arguments is Windows 
speficic so I don't comment them here.

+NTSTATUS
+Ext2ExtentSearch(
+    IN PEXT2_IRP_CONTEXT    IrpContext,
+    IN PEXT2_VCB            Vcb,
+    IN PEXT2_MCB            Mcb,
+    IN ULONG                Index,
+    IN BOOLEAN              Alloc,
+    IN PVOID                ExtentHeader,
+    IN BOOLEAN              UnpinIndexBlock,
+    IN PBCB                 BcbToUnpin,
+    OUT PULONG              Block,
+    OUT PULONG              Number
+    )
+{
+    EXT4_EXTENT_HEADER *eh;
+    EXT4_EXTENT_IDX *ei;
+    EXT4_EXTENT *ex;
+    LARGE_INTEGER offset;
+    PBCB bcb;
+    PVOID ib;
+    int i;
+    NTSTATUS status;
+
+    *Block = 0;
+    *Number = 0;
+
+    eh = (EXT4_EXTENT_HEADER *) ExtentHeader;
+
+    if (eh != NULL && eh->eh_magic == EXT4_EXT_MAGIC) {
+        DEBUG(DL_INF, ("eh_magic=%x eh_entries=%u eh_max=%u eh_depth=%u eh_generation=%u\n", (ULONG)eh->eh_magic, (ULONG)eh->eh_entries, (ULONG)eh->eh_max, (ULONG)eh->eh_depth, eh->eh_generation ));
+        if (eh->eh_depth == 0) {
+            ex = EXT_FIRST_EXTENT(eh);
+            for (i = 0; i < eh->eh_entries; i++, ex++) {
+                DEBUG(DL_INF, ("ee_block=%u ee_len=%u ee_start_hi=%u ee_start_lo=%u ext_to_block(extent)=%u\n", ex->ee_block, (ULONG)ex->ee_len, (ULONG)ex->ee_start_hi, ex->ee_start_lo, ext_to_block(ex) ));
+                if (Index >= ex->ee_block && Index < ex->ee_block + ex->ee_len) {
+                    *Block = (ULONG) (ext_to_block(ex) + (Index - ex->ee_block));
+                    *Number = ex->ee_block + ex->ee_len - Index;
+                    DEBUG(DL_INF, ("Index=%u Block=%u Number=%u\n", Index, *Block, *Number ));
+                    if (UnpinIndexBlock) {
+                        CcUnpinData(BcbToUnpin);
+                    }
+                    return STATUS_SUCCESS;
+                }
+            }
+            DEBUG(DL_ERR, ("Ext2ExtentSearch: search for extent failed on file or directory %wZ\n", &Mcb->FullName ));
+            DEBUG(DL_ERR, ("eh_magic=%x eh_entries=%u eh_max=%u eh_depth=%u eh_generation=%u\n", (ULONG)eh->eh_magic, (ULONG)eh->eh_entries, (ULONG)eh->eh_max, (ULONG)eh->eh_depth, eh->eh_generation ));
+        } else {
+            ei = EXT_FIRST_INDEX(eh);
+            DEBUG(DL_INF, ("Index=%u ei_block=%u eh_entries=%u\n", Index, ei->ei_block, eh->eh_entries ));
+            for (i = 0; i < eh->eh_entries; i++, ei++) {
+                if(Index >= ei->ei_block) {
+                    DEBUG(DL_INF, ("idx_to_block(index)=%u\n", idx_to_block(ei) ));
+                    offset.QuadPart = idx_to_block(ei) * Vcb->BlockSize;
+                    status = STATUS_SUCCESS;
+                    __try {
+                        if ( !CcPinRead (
+                            Vcb->Volume,
+                            &offset,
+                            Vcb->BlockSize,
+                            Ext2CanIWait(),
+                            &bcb,
+                            &ib )) {
+                                status = STATUS_CANT_WAIT;
+                        }
+                    } __except (EXCEPTION_EXECUTE_HANDLER) {
+                        status = GetExceptionCode();
+                    }
+                    if (!NT_SUCCESS(status)) {
+                        DEBUG(DL_ERR, ("Ext2ExtentSearch: CcPinRead failed with status %x\n", status ));
+                        return status;
+                    }
+                    return Ext2ExtentSearch(
+                        IrpContext,
+                        Vcb,
+                        Mcb,
+                        Index,
+                        Alloc,
+                        ib,
+                        TRUE,
+                        bcb,
+                        Block,
+                        Number
+                        );
+                }
+            }
+            DEBUG(DL_ERR, ("Ext2ExtentSearch: search for extent failed on file or directory %wZ\n", &Mcb->FullName ));
+            if (Alloc) {
+                DEBUG(DL_ERR, ("possible because extending a file or directory that is stored using ext4 exents is not supported yet\n" ));
+            }
+            DEBUG(DL_ERR, ("eh_magic=%x eh_entries=%u eh_max=%u eh_depth=%u eh_generation=%u\n", (ULONG)eh->eh_magic, (ULONG)eh->eh_entries, (ULONG)eh->eh_max, (ULONG)eh->eh_depth, eh->eh_generation ));
+        }
+    }
+
+    if (UnpinIndexBlock) {
+        CcUnpinData(BcbToUnpin);
+    }
+
+    return STATUS_DISK_CORRUPT_ERROR;
  }
