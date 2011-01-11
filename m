From: Lawrence Greenfield <leg@google.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Date: Tue, 11 Jan 2011 16:13:42 -0500
Message-ID: <AANLkTimwmJ_ZoE9oAuA1WGhCgK585jDznqnc6k0=9Ntb@mail.gmail.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<20101109011222.GD2715@dastard>
	<20101109033038.GF3099@thunk.org>
	<20101109044242.GH2715@dastard>
	<20101109214147.GK3099@thunk.org>
	<20101109234049.GQ2715@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Josef Bacik <josef@redhat.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
	cluster-devel@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101109234049.GQ2715@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 9, 2010 at 6:40 PM, Dave Chinner <david@fromorbit.com> wrot=
e:
> On Tue, Nov 09, 2010 at 04:41:47PM -0500, Ted Ts'o wrote:
>> On Tue, Nov 09, 2010 at 03:42:42PM +1100, Dave Chinner wrote:
>> > Implementation is up to the filesystem. However, XFS does (b)
>> > because:
>> >
>> > =C2=A0 =C2=A0 1) it was extremely simple to implement (one of the
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0advantages of having an exceedingly com=
plex allocation
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0interface to begin with :P)
>> > =C2=A0 =C2=A0 2) conversion is atomic, fast and reliable
>> > =C2=A0 =C2=A0 3) it is independent of the underlying storage; and
>> > =C2=A0 =C2=A0 4) reads of unwritten extents operate at memory spee=
d,
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0not disk speed.
>>
>> Yeah, I was thinking that using a device-style TRIM might be better
>> since future attempts to write to it won't require a separate seek t=
o
>> modify the extent tree. =C2=A0But yeah, there are a bunch of advanta=
ges of
>> simply mutating the extent tree.
>>
>> While we're on the subject of changes to fallocate, what do people
>> think of FALLOC_FL_EXPOSE_OLD_DATA, which requires either root
>> privileges or (if capabilities are in use) CAP_DAC_OVERRIDE &&
>> CAP_MAC_OVERRIDE && CAP_SYS_ADMIN. =C2=A0This would allow a trusted =
process
>> to fallocate blocks with the extent already marked initialized. =C2=A0=
I've
>> had two requests for such functionality for ext4 already.
>
> We removed that ability from XFS about three years ago because it's
> a massive security hole. e.g. what happens if the file is world
> readable, even though the process that called
> FALLOC_FL_EXPOSE_OLD_DATA was privileged and was allowed to expose
> such data? Or the file is chmod 777 after being exposed?
>
> The historical reason for such behaviour existing in XFS was that in
> 1997 the CPU and IO latency cost of unwritten extent conversion was
> significant, so users with real physical security (i.e. marines with
> guns) were able to make use of fast preallocation with no conversion
> overhead without caring about the security implications. These days,
> the performance overhead of unwritten extent conversion is minimal -
> I generally can't measure a difference in IO performance as a result
> of it - so there is simply no good rea=D1=95on for leaving such a gap=
ing
> security hole in the system.
>
> If anyone wants to read the underlying data, then use fiemap to map
> the physical blocks and read it directly from the block device. That
> requires root privileges but does not open any new stale data
> exposure problems....
>
>> (Take for example a trusted cluster filesystem backend that checks t=
he
>> object checksum before returning any data to the user; and if the
>> check fails the cluster file system will try to use some other repli=
ca
>> stored on some other server.)
>
> IOWs, all they want to do is avoid the unwritten extent conversion
> overhead. Time has shown that a bad security/performance tradeoff
> decision was made 13 years ago in XFS, so I see little reason to
> repeat it for ext4 today....

I'd make use of FALLOC_FL_EXPOSE_OLD_DATA. It's not the CPU overhead
of extent conversion. It's that extent conversion causes more metadata
operations than what you'd have otherwise, which means systems that
want to use O_DIRECT and make sure the data doesn't go away either
have to write O_DIRECT|O_DSYNC or need to call fdatasync().

cluster file system implementor,
Larry

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
