From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Quadrant write performance degradation - kernel3.10 vs kernel3.4
Date: Fri, 20 Jun 2014 10:36:15 +0800
Message-ID: <20140620023615.GA21301@gmail.com>
References: <539E8860.3010602@codeaurora.org>
 <20140616192009.GD9743@birch.djwong.org>
 <alpine.LFD.2.00.1406170949020.2148@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Tanya Brokhman <tlinder@codeaurora.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	kdorfman@codeaurora.org, merez@codeaurora.org,
	Dolev Raviv <draviv@codeaurora.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1406170949020.2148@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 17, 2014 at 09:52:46AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Mon, 16 Jun 2014, Darrick J. Wong wrote:
>=20
> > Date: Mon, 16 Jun 2014 12:20:09 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: Tanya Brokhman <tlinder@codeaurora.org>
> > Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
> >     kdorfman@codeaurora.org, merez@codeaurora.org,
> >     Dolev Raviv <draviv@codeaurora.org>
> > Subject: Re: Quadrant write performance degradation - kernel3.10 vs=
 kernel3.4
> >=20
> > On Mon, Jun 16, 2014 at 09:02:08AM +0300, Tanya Brokhman wrote:
> > > Hello,
> > > Recently we encountered a performance degradation on 3.10kernel
> > > based build, compared to 3.4 based one, when running the fs_write
> > > Quadrant benchmark.
> > > We profiled the test and came to the conclusion that the root cau=
se
> > > of the degradation is in the vfs_write call stack (overhead of
> > > 2611.2us is observed in 3.10 kernel compared to 3.4):
> > >=20
> > > ret_fast_syscall
> > > SyS_write
> > > vfs_write (total time spent: 3.10kernel-21295us, 3.4kernel-18683.=
79us)
> > > do_sync_write
> > > ext4_file_write
> > > generic_file_aio_write (total time spent: 3.10kernel-19124.4us,
> > > 3.4kernel-16815us)
> > > __generic_file_aio_write
> > > generic_file_buffered_write
> > > ext4_da_write_begin (total time spent: 3.10kernel-10935.2us,
> > > 3.4kernel-8444.6us)
> > > __block_write_begin
> > > ext4_da_get_block_prep (total time spent: 3.10kernel-5402.6us,
> > > 3.4kernel-3576.8us)
> > > ext4_es_lookup_extent  (total time spent: 3.10kernel-2219.7us,
> > > 3.4kernel-0us)
[snip]
> > > 2) Extents status tracking: https://git.kernel.org/cgit/linux/ker=
nel/git/stable/linux-stable.git/tree/fs/ext4/extents_status.c?id=3Drefs=
/tags/v3.10.42#n20
> > > =E2=80=9CThere is a cache extent for write access, so if writes a=
re not very
> > > random, adding space operations are in O(1) time.=E2=80=9D
> >=20
> > I'm no expert on the extent status cache, but this seems like a pos=
sible cause.
>=20
> Exactly, there has been some fixes since the introduction of extent
> status tree, however I've noticed some performance going down as
> well and I believe that extent status tree is to blame.
>=20
> AFAIK you can not turn it off in any way, but there might be some
> way to test it's overhead. Zheng, do you have any suggestions ?

Sigh, sorry for the delay reply.

Lukas, Could you please share your test with me?  From the calltrace it
seems that the latency is in ext4_da_get_block_prep.  It is not easy to
disable ext4_es_lookup_extent() because we need to lookup delayed exten=
t
from extent status tree and determine whether or not we need to reserve
some disk spaces.

Tanya, I really appreciate if you can disable delalloc and re-run your
test.  You can use the following command to turn off the delalloc
feature.

 $ sudo mount -t ext4 -o remount,nodelalloc ${DEV} ${MNT}

Thanks,
                                                - Zheng

>=20
> Thanks!
> -Lukas
>=20
> >=20
> > --D
> > >=20
> > > We tried pick up several performance-enhancement patches from the
> > > community, released between 3.10 and 3.14 kernel versions. The
> > > performance was almost the same.
> > >=20
> > > I was wondering what performance tests were performed on these
> > > features? Has anyone encountered same issue?
> > >=20
> > > Best Regards
> > > Tanya Brokhman
> > > --=20
> > > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is=
 a member
> > > of Code Aurora Forum, hosted by The Linux Foundation
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
