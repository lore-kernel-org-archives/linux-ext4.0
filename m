From: tytso@mit.edu
Subject: Re: Bug#564084: debugfs: logdump -b<block> show incorrect
 allocation status in block  bitmap
Date: Sun, 14 Mar 2010 19:02:30 -0400
Message-ID: <20100314230230.GB5340@thunk.org>
References: <5914604b1001070757x7574f111qd578f499f9f7cab8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: control@bugs.debian.org, linux-ext4@vger.kernel.org
To: Anon Sricharoenchai <anon.hui@gmail.com>, 564084@bugs.debian.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46119 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab0CNXCx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Mar 2010 19:02:53 -0400
Content-Disposition: inline
In-Reply-To: <5914604b1001070757x7574f111qd578f499f9f7cab8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tags 564084 +pending
thanks

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=564084

On Thu, Jan 07, 2010 at 10:57:25PM +0700, Anon Sricharoenchai wrote:
> 
> *** Please type your report below this line ***
> "logdump -b<block>" command in debugfs show incorrect allocation status
> in block bitmap

Thanks for reporting this bug.  I believe a much simpler fix for this
problem is:

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 9a7108a..9364ce4 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -619,7 +619,7 @@ static void dump_metadata_block(FILE *out_file, struct journal_source *source,
 		int offset;
 
 		super = current_fs->super;
-		offset = ((fs_blocknr - super->s_first_data_block) %
+		offset = ((block_to_dump - super->s_first_data_block) %
 			  super->s_blocks_per_group);
 
 		fprintf(out_file, "    (block bitmap for block %u: "

				       	      	     - Ted
