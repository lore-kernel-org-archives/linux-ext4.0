From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 2/3][RFC] ext3: add a message in remount/umount for ext3
Date: Wed, 16 Sep 2009 13:49:21 +0900
Message-ID: <20090916134921.c2eb5fca.toshi.okajima@jp.fujitsu.com>
References: <20090915152407.dd0fe2c8.toshi.okajima@jp.fujitsu.com>
	<20090915142333.GP2537@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36807 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZIPExc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2009 00:53:32 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8G4rXsF003136
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 16 Sep 2009 13:53:33 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 1E22645DE4F
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:53:33 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id F2C1245DE4E
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:53:32 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id DA3131DB8038
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:53:32 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 92D191DB8037
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:53:32 +0900 (JST)
In-Reply-To: <20090915142333.GP2537@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

On Tue, 15 Sep 2009 08:23:33 -0600
Andreas Dilger <adilger@sun.com> wrote:
> [NB - removed Stephen from CC list]
> 
> On Sep 15, 2009  15:24 +0900, Toshiyuki Okajima wrote:
> > +static void ext3_print_mount_message(struct super_block *sb, 
> > +					int is_remount)
> > +{
> > +	printk(KERN_INFO "EXT3 FS %s on %s, ", 
> > +			is_remount? "remounted": "mounted", sb->s_id);
> > +	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
> > +		char b[BDEVNAME_SIZE];
> > +
> > +		printk("external journal on %s\n",
> > +			bdevname(EXT3_SB(sb)->s_journal->j_dev, b));
> > +	} else {
> > +		printk("internal journal\n");
> > +	}
> 
> This won't necessarily work as you expected, because the separate
> printk() calls will result in the message being printed on separate
> lines of output.
Thanks for your comment.
I'll apply it into new patch.

> 
> Instead, this should print this all in a single line:
> 
> 	char jbuf[BDEVNAME_SIZE + 20] = "internal journal";
> 
> 	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
> 		sprintf(jbuf, "external journal on ");
> 		bdevname(EXT3_SB(sb)->s_journal->j_dev,
> 			 jbuf + 20));
> 	}
> 	
> 	printk(KERN_INFO "EXT3 FS %s on %s, %s\n", 
> 	       is_remount? "remounted": "mounted", sb->s_id, jbuf)
> 
> > @@ -1296,15 +1317,6 @@ static int ext3_setup_super(struct super
> > -	printk(KERN_INFO "EXT3 FS on %s, ", sb->s_id);
> > -	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
> > -		char b[BDEVNAME_SIZE];
> > -
> > -		printk("external journal on %s\n",
> > -			bdevname(EXT3_SB(sb)->s_journal->j_dev, b));
> > -	} else {
> > -		printk("internal journal\n");
> > -	}
> 
> Interesting, it was broken already...  Well, best to fix it anyways.
> The same should be done for the ext4 patch.

Thanks,
Toshiyuki Okajima
