From: Nick Alcock <nick.alcock@esperi.org.uk>
Subject: Re: Trouble mounting metadata_csum ext4 filesystems with v4.7.x after c9274d891869880648c4ee9365df3ecc7ba2e285: not enough inode bytes checksummed?
Date: Sun, 15 Jan 2017 17:34:03 +0000
Message-ID: <87wpdww7lg.fsf@esperi.org.uk>
References: <87zin42crs.fsf@esperi.org.uk>
        <20160920055216.GD9309@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        daeho.jeong@samsung.com, linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160920055216.GD9309@birch.djwong.org> (Darrick J. Wong's
        message of "Mon, 19 Sep 2016 22:52:16 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 20 Sep 2016, Darrick J. Wong said:
> I /think/ the fix in this case is to hoist the last ext4_chksum call
> out of the EXT4_FITS_IN_INODE blob:
>
> if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
> 	offset = offsetof(struct ext4_inode, i_checksum_hi);
> 	csum = ext4_chksum(sbi, csum, (__u8 *)raw +
> 			   EXT4_GOOD_OLD_INODE_SIZE,
> 			   offset - EXT4_GOOD_OLD_INODE_SIZE);
> 	if (EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
> 		csum = ext4_chksum(sbi, csum, (__u8 *)&dummy_csum,
> 				   csum_size);
> 		offset += csum_size;
> 	}
> 	csum = ext4_chksum(sbi, csum, (__u8 *)raw + offset,
> 			   EXT4_INODE_SIZE(inode->i_sb) - offset);
> }
>
> Can you give that a try?

Months too late, I can finally confirm that the patch below fixes it for
me (tested in 4.9.4), and I'm running with metadata csums on everywhere
again. :)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 27e4348..ed79c6e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -71,10 +71,10 @@ static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
 			csum = ext4_chksum(sbi, csum, (__u8 *)&dummy_csum,
 					   csum_size);
 			offset += csum_size;
-			csum = ext4_chksum(sbi, csum, (__u8 *)raw + offset,
-					   EXT4_INODE_SIZE(inode->i_sb) -
-					   offset);
 		}
+		csum = ext4_chksum(sbi, csum, (__u8 *)raw + offset,
+				   EXT4_INODE_SIZE(inode->i_sb) -
+				   offset);
 	}
 
 	return csum;

