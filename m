From: Mark Nelson <markn@au1.ibm.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Thu, 26 Feb 2009 10:20:34 +1100
Message-ID: <200902261020.34325.markn@au1.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <alpine.LRH.2.00.0902251430410.4063@vixen.sonytel.be> <200902260945.41990.markn@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Jan Kara <jack@ucw.cz>, Jan Kara <jack@suse.cz>,
	Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: linuxppc-dev@ozlabs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51767 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZBYXTC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 18:19:02 -0500
In-Reply-To: <200902260945.41990.markn@au1.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 26 Feb 2009 09:45:41 am Mark Nelson wrote:
> On Thu, 26 Feb 2009 12:31:20 am Geert Uytterhoeven wrote:
> > On Wed, 25 Feb 2009, Mark Nelson wrote:
> > > On Wed, 25 Feb 2009 08:50:46 pm Geert Uytterhoeven wrote:
> > > > On Wed, 25 Feb 2009, Mark Nelson wrote:
> > > > > On Tue, 24 Feb 2009 05:38:37 pm Sachin P. Sant wrote:
> > > > > > Jan Kara wrote:
> > > > > > >   Hmm, OK. But then I'm not sure how that can happen. Obviously, memcpy
> > > > > > > somehow got beyond end of the page referenced by bh->b_data. So it means
> > > > > > > that le16_to_cpu(entry->e_value_offs) + size > page_size. But
> > > > > > > ext3_xattr_find_entry() calls ext3_xattr_check_entry() which in
> > > > > > > particular checks whether e_value_offs + e_value_size isn't greater than
> > > > > > > bh->b_size. So I see no way how memcpy can get beyond end of the page.
> > > > > > >   Sachin, is the problem reproducible? If yes, can you send us contents
> > > > > > >   
> > > > > > Yes, i am able to recreate this problem easily. As i had mentioned if the
> > > > > > earlier kernel is booted with selinux enabled and then 2.6.29-rc6 is booted
> > > > > > i get this crash. But if i specify selinux=0 at command line, 2.6.29-rc6 boots
> > > > > > without any problem.
> > > > > 
> > > > > Hi Sanchin and Geert,
> > > > > 
> > > > > Does the patch below fix the problems you're seeing? If it does I'll send
> > > > > a properly written up and formatted patch to linuxppc-dev (as well as
> > > > > another one to fix the same problem in copy_tofrom_user()).
> > > > 
> > > > Unfortunately not, now it crashes while accessing the memory pointed to by
> > > > GPR16, in
> > > > 
> > > > NIP: copy_page_range+x0608/0x628
> > > > LR:  dup_mm+0x2e4/0x428
> > > > Trace: debug_table+0xcc70/0x1afe0 (unreliable)
> > > > dup_mm+0x2e4/0x428
> > > > copy_process+0x86c/0xf9c
> > > > do_fork+0x188/0x39c
> > > > sys_clone+0x58/0x70
> > > > ppc_clone+0x8/0xc
> > > > 
> > > > However, after reverting 25d6e2d7c58ddc4a3b614fc5381591c0cfe66556, I still see
> > > > similar problems as above (crash in copy_page_range()).
> > > > Which makes me think that
> > > >   1. Your new patch fixes the problem introduced by 25d6e2d7,
> > > >   2. There's still another issue than the one introduced by 25d6e2d7.
> > > 
> > > Does the following patch fix the errors you're seeing? (it applies the
> > > same fix as the previous patch but this time to copy_tofrom_user, which
> > > I updated in a4e22f02f5b6518c1484faea1f88d81802b9feac)
> > 
> > Thanks, but I still get crashes in copy_page_range().
> > 
> 
> Hmmm... I'm out of ideas for the moment, but thanks for testing anyway!
> 
> Mark
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 

If you revert both 25d6e2d7c58ddc4a3b614fc5381591c0cfe66556 and
a4e22f02f5b6518c1484faea1f88d81802b9feac, does it help? You could also
try to revert 57dda6ef5bd5b9e60410477ad29e654097e2cca1 just in case I
need to keep wearing the brown paper bag for a bit longer :)

Thanks!

Mark
