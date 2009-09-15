From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/3][RFC] ext3: add a message in remount/umount for ext3
Date: Tue, 15 Sep 2009 08:23:33 -0600
Message-ID: <20090915142333.GP2537@webber.adilger.int>
References: <20090915152407.dd0fe2c8.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64736 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZIOOXd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Sep 2009 10:23:33 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8FENZVj000047
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 07:23:35 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ000700NR8AP00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 15 Sep 2009 07:23:34 -0700 (PDT)
In-reply-to: <20090915152407.dd0fe2c8.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[NB - removed Stephen from CC list]

On Sep 15, 2009  15:24 +0900, Toshiyuki Okajima wrote:
> +static void ext3_print_mount_message(struct super_block *sb, 
> +					int is_remount)
> +{
> +	printk(KERN_INFO "EXT3 FS %s on %s, ", 
> +			is_remount? "remounted": "mounted", sb->s_id);
> +	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
> +		char b[BDEVNAME_SIZE];
> +
> +		printk("external journal on %s\n",
> +			bdevname(EXT3_SB(sb)->s_journal->j_dev, b));
> +	} else {
> +		printk("internal journal\n");
> +	}

This won't necessarily work as you expected, because the separate
printk() calls will result in the message being printed on separate
lines of output.

Instead, this should print this all in a single line:

	char jbuf[BDEVNAME_SIZE + 20] = "internal journal";

	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
		sprintf(jbuf, "external journal on ");
		bdevname(EXT3_SB(sb)->s_journal->j_dev,
			 jbuf + 20));
	}
	
	printk(KERN_INFO "EXT3 FS %s on %s, %s\n", 
	       is_remount? "remounted": "mounted", sb->s_id, jbuf)

> @@ -1296,15 +1317,6 @@ static int ext3_setup_super(struct super
> -	printk(KERN_INFO "EXT3 FS on %s, ", sb->s_id);
> -	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
> -		char b[BDEVNAME_SIZE];
> -
> -		printk("external journal on %s\n",
> -			bdevname(EXT3_SB(sb)->s_journal->j_dev, b));
> -	} else {
> -		printk("internal journal\n");
> -	}

Interesting, it was broken already...  Well, best to fix it anyways.
The same should be done for the ext4 patch.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

