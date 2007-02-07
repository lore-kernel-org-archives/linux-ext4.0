From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Wed, 7 Feb 2007 18:46:22 +0900
Message-ID: <097a01c74a9c$d62fa9f0$4168010a@bsd.tnes.nec.co.jp>
References: <20070116210520sho@rifu.tnes.nec.co.jp> <20070206173344.a3e8e37a.akpm@linux-foundation.org> <45C94B61.4070105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
To: "Eric Sandeen" <sandeen@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34795 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161102AbXBGJqR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Feb 2007 04:46:17 -0500
Received: from mailgate4.nec.co.jp (mailgate53.nec.co.jp [10.7.69.184])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l179kFM7011071
	for <linux-ext4@vger.kernel.org>; Wed, 7 Feb 2007 18:46:15 +0900 (JST)
Received: (from root@localhost) by mailgate4.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l179kFc03233 for linux-ext4@vger.kernel.org; Wed, 7 Feb 2007 18:46:15 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l179kFL10070 for <linux-ext4@vger.kernel.org>; Wed, 7 Feb 2007 18:46:15 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070207.184615.26501276 for <linux-ext4@vger.kernel.org>
	; Wed, 7 Feb 2007 18:46:15 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

>>> +ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
>>> + pgoff_t from_page,  pgoff_t dest_from_page,
>>> + pgoff_t count_page, unsigned long *delete_start) +{
>>> + struct ext4_ext_path *org_path = NULL;
>>> + struct ext4_ext_path *dest_path = NULL;
>>> + struct ext4_extent   *oext, *dext;
>>> + struct ext4_extent   tmp_ext;
>>> + int err = 0;
>>> + int depth;
>>> + unsigned long from, count, dest_off, diff, replaced_count = 0;
>>
>> These should be sector_t, shouldn't they?
>
> At some point should we start using blkcnt_t properly? (block-in[-large]-file, not 
> block-in[-large]-device?)  I think that's what it was introduced for, although it's not 
> in wide use at this point.
>
> I guess the type really isn't used anywhere else; just in the inode's i_blocks.  Hmm.

On reflection, I think we should use ext4_fsblk_t in this case, because
some ext4 codes such as ext4_ext_get_blocks() use it.
int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
                        ext4_fsblk_t iblock,
So I would like to change "unsigned long" into ext4_fsblk_t in my next patch.

Cheers, Takashi 
