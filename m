From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Unexpected writes seen on a Read-only, DAX enabled EXT4 fs
Date: Mon, 11 Sep 2017 12:21:12 -0600
Message-ID: <20170911182112.GA20005@linux.intel.com>
References: <2036030243.251059.1504977026265.ref@mail.yahoo.com>
 <2036030243.251059.1504977026265@mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Soccer Liu <soccer_liu-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2036030243.251059.1504977026265-sAHhhX/85wgbqTNvkayDYw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Sat, Sep 09, 2017 at 05:10:26PM +0000, Soccer Liu wrote:
> Hi:
> =A0 I was surprised to see a few write operations called into
> ext4_dax_huge_fault with FAULT_FLAG_WRITE set on vmf->flags
> Are those writes expected at all?
> static int ext4_dax_huge_fault(struct vm_fault *vmf,
>  enum page_entry_size pe_size)
> {
> ...
>  bool write =3D vmf->flags & FAULT_FLAG_WRITE;
> Based on the following Mount documentation below, I did mount this ext fs
> with ro and noloadAre there any other options that I could use to totally
> eliminate those unexpected writes?
>    =

>    - -r, --read-only
>       - Mount the filesystem read-only. A synonym is -o ro.Note that,
>       depending on the filesystem type, state and kernel behavior, the
>       system may still write to the device. For example, Ext3 or ext4 will
>       replay itsjournal if the filesystem is dirty. To prevent this kind =
of
>       write access, you may want to mount ext3 or ext4 filesystem with
>       "ro,noload" mount options or setthe block device to read-only mode,
>       see command blockdev(8).  -    =

> =

> Related DMESG output...
> =

> [=A0=A0=A0 0.891653] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL,=
 use at your own risk
> [=A0=A0=A0 0.892736] EXT4-fs (pmem0): mounted filesystem without journal.=
 Opts: noload,dax
> [=A0=A0=A0 0.898293] EXT4-fs (sda): mounted filesystem without journal. O=
pts: (null)
> [=A0=A0=A0 0.902574] random: fast init done
> [=A0=A0=A0 0.926157] IPVS: ftp: loaded support on port[0] =3D 21
> // My private debug messages
> [=A0=A0=A0 0.997224] EXT4-fs (pmem0): write is 1 handle =3D 0xfffffffffff=
fffe2 <--read-only device=A0
> [=A0=A0=A0 0.998052] EXT4-fs (pmem0): write is 1 handle =3D 0xfffffffffff=
fffe2
> [=A0=A0=A0 0.998787] EXT4-fs (pmem0): write is 1 handle =3D 0xfffffffffff=
fffe2
> [=A0=A0=A0 0.999720] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0=A0 1.004626] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0=A0 1.005359] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0=A0 1.006128] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0=A0 1.006824] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0=A0 1.007499] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0=A0 1.008149] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0=A0 7.320626] random: crng init done
> [=A0=A0 18.780447] EXT4-fs: 53 callbacks suppressed
> [=A0=A0 18.781900] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0 18.783392] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0 18.790661] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0 18.792042] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0 18.793321] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0 18.795005] EXT4-fs (pmem0): write is 0 handle =3D 0x0
> [=A0=A0 18.795204] EXT4-fs (pmem0): write is 1 handle =3D 0xfffffffffffff=
fe2
> [=A0=A0 18.795209] EXT4-fs (pmem0): write is 1 handle =3D 0xfffffffffffff=
fe2
> [=A0=A0 18.795213] EXT4-fs (pmem0): write is 1 handle =3D 0xfffffffffffff=
fe2
> [=A0=A0 18.795257] EXT4-fs (pmem0): write is 0 handle =3D 0x0

Adding the ext4 list.

I'm pretty sure that this is ext4/mm behavior that is independent of DAX.  =
DAX
doesn't really have any impact on whether or not write page faults happen o=
n a
RO ext4 filesystem, though this fix from Randy Dodgen:

https://www.spinics.net/lists/linux-ext4/msg58075.html

shows that FAULT_FLAG_WRITE can be set on DAX read-only ext4 mounts when
executing binaries, though in this case the write is going to a COW page.

- Ross
