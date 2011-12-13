From: Witold Baryluk <baryluk-W6Hso+/wx31C2Nf1M/Lcnw@public.gmane.org>
Subject: Re: [Bug #39732] JBD: Spotted dirty metadata buffer (dev = dm-2,
 blocknr = 2512725). There's a risk of filesystem corruption in case of
 system crash.
Date: Wed, 14 Dec 2011 00:43:16 +0100
Message-ID: <20111213234316.GG28734@smp.if.uj.edu.pl>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
 <gUVi6eNP8RE.A.z7G.OfpWOB@chimera>
 <20111213041144.GF28734@smp.if.uj.edu.pl>
 <20111213173542.GH11747@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Maciej Rutecki <maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Florian Mickler <florian-sVu6HhrpSfRAfugRpC6u6w@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111213173542.GH11747-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 12-13 18:35, Jan Kara wrote:
>   Hi,
> 
> On Tue 13-12-11 05:11:44, Witold Baryluk wrote:
> > On 08-28 21:01, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.39 and 3.0.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.39 and 3.0.  Please verify if it still should
> > > be listed and let the tracking team know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39732
> > > Subject		: JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr = 2512725). There's a risk of filesystem corruption in case of system crash.
> > > Submitter	: Witold Baryluk <baryluk-W6Hso+/wx31C2Nf1M/Lcnw@public.gmane.org>
> > > Date		: 2011-07-22 04:22 (38 days old)
> > 
> > This bug still exists in 3.1.0 and 3.2.0-rc5
> > 
> > I spoted it again few days ago, because I moved from me laptop with 2GB
> > to temporary desktop with 256MB of RAM, and not it
> > triggers like a mad.
> > 
> > So my initial suspicious that it only shows up on big memory
> > presure was correct.
> > 
> > 
> > It is just like this 
> > # dmesg | grep dirty
> > [122647.953872] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 1019852). There's a risk of filesystem corruption in case of system crash.
> > [122647.954598] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 1043195). There's a risk of filesystem corruption in case of system crash.
> > [122647.955213] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 1043197). There's a risk of filesystem corruption in case of system crash.
> > [122689.978864] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 498559). There's a risk of filesystem corruption in case of system crash.
> > [122705.485461] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 68282). There's a risk of filesystem corruption in case of system crash.
> > [122705.486046] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 68284). There's a risk of filesystem corruption in case of system crash.
> > [122705.496916] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 68365). There's a risk of filesystem corruption in case of system crash.
> > [122705.612423] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 69218). There's a risk of filesystem corruption in case of system crash.
> > [122706.531297] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 833896). There's a risk of filesystem corruption in case of system crash.
> > [122720.863807] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 914979). There's a risk of filesystem corruption in case of system crash.
> > [122721.046789] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 890090). There's a risk of filesystem corruption in case of system crash.
> > [122721.088280] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 916474). There's a risk of filesystem corruption in case of system crash.
> > [122721.176979] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 928182). There's a risk of filesystem corruption in case of system crash.
> > [122721.177593] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 927783). There's a risk of filesystem corruption in case of system crash.
> > [122721.371654] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 920655). There's a risk of filesystem corruption in case of system crash.
> > [122721.543676] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 967035). There's a risk of filesystem corruption in case of system crash.
> > [122728.396687] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 1043474). There's a risk of filesystem corruption in case of system crash.
> > [122736.283876] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 713478). There's a risk of filesystem corruption in case of system crash.
> > [122743.576350] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 745551). There's a risk of filesystem corruption in case of system crash.
> > [122743.889259] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 828117). There's a risk of filesystem corruption in case of system crash.
> > [122752.077022] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 905082). There's a risk of filesystem corruption in case of system crash.
> > [122752.125005] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 905294). There's a risk of filesystem corruption in case of system crash.
> > [122752.784390] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 1030306). There's a risk of filesystem corruption in case of system crash.
> > [122752.785053] JBD: Spotted dirty metadata buffer (dev = dm-3, blocknr = 1031593). There's a risk of filesystem corruption in case of system crash.
> > #
> > 
> > dm-4 is ext4 partition mounted at /var
> > dm-4 is on LVM on luksCrypt on ATA drive.
> > 
> > I'm using currently stock Debian testing kernel:
> > $ uname -a
> > Linux sredniczarny 3.1.0-1-686-pae #1 SMP Tue Nov 29 19:01:56 UTC 2011 i686 GNU/Linux
> > $ cat /proc/version
> > Linux version 3.1.0-1-686-pae (Debian 3.1.4-1) (waldi-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org) (gcc version 4.6.2 (Debian 4.6.2-4) ) #1 SMP Tue Nov 29 19:01:56 UTC 2011
> > $
> > 
> > 32-bit intel compatible cpu
>   Thanks for report. Actually I was able to reproduce these messages with
> data=journal mode as well when running bash_shared_mapping test. The
> culprit of the problem is that block_mkwrite() as used in
> ext4_page_mkwrite() marks buffers dirty and JBD2 notices this before
> we clear dirty bits later in ext4_page_mkwrite() (since JBD2 doesn't use
> page lock for protection when inspecting buffers). So for data=journal mode
> we'll probably have to reimplement what block_page_mkwrite() does in a
> slightly different manner tweaked for the needs of data=journal mode.
> 

Yes, I run data=journal, I am sorry I not mentioned it first!
(I think I did this in initial bug report, but to this day
bugzilla is not working :/ )

# grep /var /proc/mounts
/dev/mapper/sredniczarny-var /var ext4 rw,relatime,user_xattr,acl,commit=120,barrier=1,nodelalloc,data=journal 0 0
#

It is somehow important I think, for two reasons
1) I run on laptop, so risk of power loss is high
2) I use data=journal for having higher data integrity / reliability,
   and having it opossing effect (by not only not possibly providing
   this reliability, but also compromising metadata and filesystem structure
   integrity) is somehow not anyone would want (especially when using data=journal).

Regards,
Witek


-- 
Witold Baryluk
