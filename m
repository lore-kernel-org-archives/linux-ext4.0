From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
Date: Thu, 17 Dec 2015 20:51:22 -0600
Message-ID: <567374AA.6030007@sandeen.net>
References: <567212DA.8050808@cn.fujitsu.com> <567228EF.80007@redhat.com>
	<5673616C.1040706@cn.fujitsu.com>
	<1450404066.6498.70.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Anton Mitterer <calestyo@scientia.net>,
	Qu Wenruo <quwenruo@cn.fujitsu.com>, Eric Sandeen <sandeen@redhat.com>,
	fsdevel <linux-fsdevel@vger.kernel.org>, btrfs
	<linux-btrfs@vger.kernel.org>, kzak@redhat.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1450404066.6498.70.camel@scientia.net>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org



On 12/17/15 8:01 PM, Christoph Anton Mitterer wrote:
> On Fri, 2015-12-18 at 09:29 +0800, Qu Wenruo wrote:
>> Given that nothing in the documentation implies that the block
>>> device itself
>>> must remain unchanged on a read-only mount, I don't see any problem
>>> which
>>> needs fixing.  MS_RDONLY rejects user IO; that's all.
>>
>> And thanks for the info provided by Karel, it's clear that at least 
>> mount(8) itself already has explain on what ro will do and what it
>> won't do.
> 
> I wouldn't really agree, here. At least not from the non-developer side
> (and one should hope filesystems and their manpages aren't only made
> for fs-devlopers).
> 
> The manpage says:
>> ro     Mount the filesystem read-only.
>> rw     Mount the filesystem read-write.
> 
> IMHO, that leaves absolutely unclear, what this actually means,
> especially given that most end-users will probably consider the
> filesystem and its device being basically "the same".

<lots of words snipped>

Karel pointed out that recent mount(8) says:

>    -r, --read-only
>        Mount the filesystem read-only.  A synonym is -o ro.
> 
>        Note  that,  depending  on the filesystem type, state and
>        kernel behavior, the system may still write to the device.  For
>        example, ext3 and ext4 will replay the journal if the
>        filesystem is dirty.  To prevent this kind of write access, you
>        may want to mount an ext3 or ext4 filesystem with the ro,noload
>        mount options or set the  block  device itself to read-only
>        mode, see the blockdev(8) command.

which should leave nothing to the imagination.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
