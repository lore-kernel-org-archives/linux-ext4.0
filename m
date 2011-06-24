From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Fri, 24 Jun 2011 11:03:52 -0500
Message-ID: <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com>
 <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
 <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
 <26AE8923-4DEA-43FF-8F79-1D5AA665A344@boeing.com>
 <20110405230538.GH2832@thunk.org>
 <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
 <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
 <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
Reply-To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>, 615998@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Sean Ryle <seanbo@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        "615998@bugs.debian.org" <615998@bugs.debian.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Sachin Sant
	<sachinp@in.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.615998.B615998.130893147029964@bugs.debian.org>
In-Reply-To: <20110624134659.GB26380@quack.suse.cz>
Content-Language: en-US
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

On Jun 24, 2011, at 09:46, Jan Kara wrote:
> On Thu 23-06-11 16:19:08, Moffett, Kyle D wrote:
>> Besides which, line 534 in the Debian 2.6.32 kernel I am using is this
>> one:
>>=20
>>  J_ASSERT(commit_transaction->t_nr_buffers <=3D
>>           commit_transaction->t_outstanding_credits);
>=20
>  Hmm, OK, so we've used more metadata buffers than we told JBD2 to
> reserve. I suppose you are not using data=3Djournal mode and the filesyst=
em
> was created as ext4 (i.e. not converted from ext3), right? Are you using
> quotas?

The filesystem *is* using data=3Djournal mode.  If I switch to data=3Dorder=
ed
or data=3Dwriteback, the problem goes away.

The filesystems were created as ext4 using the e2fstools in Debian squeeze:
1.41.12, and the kernel package is 2.6.32-5-xen-amd64 (2.6.32-34squeeze1).

The exact commands I used to create the Postfix filesystems were:
  lvcreate -L  5G -n postfix dbnew
  lvcreate -L 32M -n smtp    dbnew
  mke2fs -t ext4 -L db:postfix /dev/dbnew/postfix
  mke2fs -t ext4 -L db:smtp    /dev/dbnew/smtp
  tune2fs -i 0 -c 1 -e remount-ro -o acl,user_xattr,journal_data /dev/dbnew=
/postfix
  tune2fs -i 0 -c 1 -e remount-ro -o acl,user_xattr,journal_data /dev/dbnew=
/smtp

Then my fstab has:
  /dev/mapper/dbnew-postfix /var/spool/postfix ext4 noauto,noatime,nosuid,n=
odev 0 2
  /dev/mapper/dbnew-smtp    /var/lib/postfix   ext4 noauto,noatime,nosuid,n=
odev 0 2

I don't even think I have the quota tools installed on this system; there
are certainly none configured.

>> If somebody can tell me what information would help to debug this I'd be
>> more than happy to throw a whole bunch of debug printks under that error
>> condition and try to trigger the crash with that.
>>=20
>> Alternatively I could remove that J_ASSERT() and instead add some debug
>> further down around the "commit_transaction->t_outstanding_credits--;"
>> to try to see exactly what IO it's handling when it runs out of credits.
>=20
>  The trouble is that the problem is likely in some journal list shuffling
> code because if just some operation wrongly estimated the number of neede=
d
> buffers, we'd fail the assertion in jbd2_journal_dirty_metadata():
> J_ASSERT_JH(jh, handle->h_buffer_credits > 0);

Hmm, ok...  I'm also going to turn that failing J_ASSERT() into a WARN_ON()
just to see how much further it gets.  I have an easy script to recreate th=
is
data volume even if it gets totally hosed anyways, so...

> The patch below might catch the problem closer to the place where it
> happens...
>=20
> Also possibly you can try current kernel whether the bug happens with it =
or
> not.

I'm definitely going to try this patch, but I'll also see what I can do abo=
ut
trying a more recent kernel.

Thanks!

Cheers,
Kyle Moffett=
