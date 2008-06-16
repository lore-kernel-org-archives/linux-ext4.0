From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Performance of ext4
Date: Mon, 16 Jun 2008 23:43:53 +0530
Message-ID: <20080616181353.GA20686@skywalker>
References: <18563.1213215457@alphaville.zko.hp.com> <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de> <18513.345.553912.449710@frecb006361.adech.frec.bull.fr> <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de> <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de> <20080616175408.GF3279@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, Theodore Tso <tytso@mit.edu>,
	Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757945AbYFPSOm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080616175408.GF3279@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 16, 2008 at 07:54:08PM +0200, Jan Kara wrote:
> > On Thu, 12 Jun 2008, Holger Kiehl wrote:
> > 
> > >On Thu, 12 Jun 2008, Aneesh Kumar K.V wrote:
> > >
> > >>On Thu, Jun 12, 2008 at 02:07:30PM +0000, Holger Kiehl wrote:
> > >>>This time there is no OOPS and system is still up running without any
> > >>>problem (except any process wanting to write something to this filesystem
> > >>>gets stuck forever).
> > >>>
> > >>>What can I do to help find the problem? The system is still up with all 
> > >>>those
> > >>>process hanging in D-state.
> > >>>
> > >>
> > >>if you can login to the system get the dmesg output after
> > >>
> > >>echo t > /proc/sysrq-trigger
> > >>
> > >Unfortunately I have not set CONFIG_MAGIC_SYSRQ. Tomorrow I will try to
> > >reproduce this with a kernel that has CONFIG_MAGIC_SYSRQ set.
> > >
> > After recompiling, rebooting and run afdbench first I got an OOPS and the
> > system hanged up solid. The only thing I was able to catch is this:
> > 
> >   RIP [<ffffffff803019f9>] jbd2_journal_release_jbd_inode+0xcb/0x100
> >   RSP <ffff8101fe259c18>
> > 
> > This was copied by hand. And this I cut 'cut and past' from my terminal:
> > 
> > kernel: Code: c3 e8 31 ce f3 ff 41 fe 04 24 e8 fe 3f 16 00 4c 89 fe 48 89 
> > df e8 5f cd f3 ff eb 82 48 83 7d 00 00 74 27 48 8b 55 10 48 8b 45 18 <48> 
> > 89 42 08 48 89 10 48 c7 45 18 00 02 20 00 48 c7 45 10 00 01
>   Aneesh found cause of this oops I think... Aneesh, would you send the
> fix to Holger? Thanks.
> 

That fix was mainly done with the help of Holger. Many thanks to him for
doing multiple test during weekend with different combination. He had
already confirmed that the fix worked for me. 

There is another issue that he is hitting when running the test with
mke2fs -m 0. But I think that is not related to lock inversion.

-aneesh
