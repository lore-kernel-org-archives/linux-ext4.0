From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [RFC][PATCH V3 1/4] ext4: add EXT4_IOC_CONTROL_PA to create/discard
 inode PA
Date: Thu, 02 Dec 2010 15:07:27 +0900
Message-ID: <4CF7379F.7030402@sx.jp.nec.com>
References: <4CF5E5F2.9080007@sx.jp.nec.com> <62E660B4-8AF6-4B94-B3C0-1557ACA136DB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <62E660B4-8AF6-4B94-B3C0-1557ACA136DB@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2010/12/01 19:14, Andreas Dilger wrote:
> Is the comment here wrong, or do I misunderstand that there is a 64-bit offset for the file, and only a 32-bit offset for the disk?  It doesn't make sense to create a new API that only has a 32-bit offset for the disk, since ext4 is nearly supporting 64-bit filesystem blocks.

Oops! Thank you for letting me know. I will fix the comments as follows:

struct ext4_prealloc_info {
	__u64 pi_pstart;	/* physical offset for the start of the PA from
				 * the beginning of the disk (in/out) */
	__u32 pi_lstart;	/* logical offset for the start of the PA from
				 * the beginning of the file (in/out) */

Regards,
Kazuya Mio
