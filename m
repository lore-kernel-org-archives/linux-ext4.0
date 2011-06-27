From: Lukas Czerner <lczerner@redhat.com>
Subject: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Mon, 27 Jun 2011 13:16:50 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106271312310.3845@dhcp-27-109.brq.redhat.com>
References: <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com> <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com> <26AE8923-4DEA-43FF-8F79-1D5AA665A344@boeing.com> <20110405230538.GH2832@thunk.org> <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
 <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com> <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com> <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com> <20110624134659.GB26380@quack.suse.cz> <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
Reply-To: Lukas Czerner <lczerner@redhat.com>, 615998@bugs.debian.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
        Sean Ryle <seanbo@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        "615998@bugs.debian.org" <615998@bugs.debian.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Sachin Sant <sachinp@in.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.615998.B615998.130917342827650@bugs.debian.org>
In-Reply-To: <20110624200231.GA32176@quack.suse.cz>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

On Fri, 24 Jun 2011, Jan Kara wrote:

> On Fri 24-06-11 11:03:52, Moffett, Kyle D wrote:
> > On Jun 24, 2011, at 09:46, Jan Kara wrote:
> > > On Thu 23-06-11 16:19:08, Moffett, Kyle D wrote:
> > >> Besides which, line 534 in the Debian 2.6.32 kernel I am using is this
> > >> one:
> > >> 
> > >>  J_ASSERT(commit_transaction->t_nr_buffers <=
> > >>           commit_transaction->t_outstanding_credits);
> > > 
> > >  Hmm, OK, so we've used more metadata buffers than we told JBD2 to
> > > reserve. I suppose you are not using data=journal mode and the filesystem
> > > was created as ext4 (i.e. not converted from ext3), right? Are you using
> > > quotas?
> > 
> > The filesystem *is* using data=journal mode.  If I switch to data=ordered
> > or data=writeback, the problem goes away.
>   Ah, OK. Then bug https://bugzilla.kernel.org/show_bug.cgi?id=34642 is
> probably ext3 incarnation of the same problem and it seems it's still
> present even in the current kernel - that ext3 assertion triggered even
> with 2.6.39 kernel. Frankly data=journal mode is far less tested than the
> other two modes especially with ext4, so I'm not sure how good idea is to
> use it in production.

Hi Jan,

if it is so (and it probably is, since I am not testing this mode as
well:), it would be interesting to find out whether there are many users
of this and if there are not, which is probably the case, deprecate it now,
so we can remove it later. If we are openly suggesting not to use this,
then there is probably no point in having this option in the first
place.

I vaguely remember that Ted said something about removing data=journal
mode, but I do not remember details. Ted ?

Thanks!
-Lukas
