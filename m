From: Roman Borisov <ext-roman.borisov@nokia.com>
Subject: ext3: ext4: Using uninitialized value
Date: Wed, 13 Oct 2010 18:40:22 +0400
Message-ID: <4CB5C4D6.3020201@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Roman Borisov <ext-roman.borisov@nokia.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx04.teleca.com ([212.92.145.6]:33658 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0JMOgr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Oct 2010 10:36:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Could you clarify is there a bug in fs/ext4/namei.c,
ext4_dx_find_entry() and fs/ext4/namei.c, ext3_dx_find_entry()?

<code>
static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
...
struct dx_hash_info hinfo;
...
if (namelen > 2 || name[0] != '.'|| (namelen == 2 && name[1] != '.')) {
if (!(frame = dx_probe(entry, dir, &hinfo, frames, err)))
return NULL;
} else {
frame = frames;
frame->bh = NULL; /* for dx_release() */
frame->at = (struct dx_entry *)frames; /* hack for zero entry*/
dx_set_block(frame->at, 0); /* dx_root block is 0 */
}
hash = hinfo.hash;
...
retval = ext3_htree_next_block(dir, hash, frame,
...
</code>

In the code above: hinfo.hash is not initialized in "else" case.
Should it be initialized as NULL?
Or maybe implementation doesn't assume to call ext3_htree_next_block()
in such case?

Thanks,
Roman

