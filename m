From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: e2fsprogs: Richacl support
Date: Sat, 17 Oct 2015 02:22:25 +0200
Message-ID: <CAHc6FU5B35D30Cc0-iSAfKDrCfc29paYe-tg-GGP7KEH08+2rA@mail.gmail.com>
References: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
	<20151016231615.GF15011@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20151016231615.GF15011@thunk.org>
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

On Sat, Oct 17, 2015 at 1:16 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Oct 16, 2015 at 06:03:29PM +0200, Andreas Gruenbacher wrote:
>>
>> could the richacl feature flag please be added to e2fsprogs so that we
>> won't end up with incompatible file systems?
>>
>>   https://github.com/andreas-gruenbacher/e2fsprogs
>>
>> Also, should this really be an incompatible feature flag? With a
>> read-only compatibility flag, mounting a richacl filesystem on a
>> kernel without richacl support would work but it's not safe --- it
>> could grant unwanted access to files. (The same applies to the xfs
>> support, etc.)
>
> Richacl's are represented using just extended attributes, right?

Yes.

Richacls can be enabled per file system; they are mutually exclusive
with POSIX ACLs. You usually define which kind of ACLs a filesystem
should support at filesystem create time, and that choice sticks with
the filesystem. So using a feature flag makes sense.

> Suppose we mounted a file system with richacl's on a kernel that
> didn't understand it, and we write to from that non-richacl kernel.
> What's the worse that could happen?

Two things are likely to happen. First, richacls will not be enforced;
this can cause fewer or more permissions to be granted. Second, when
files are created, permission inheritance will not take place, so when
the filesystem is later used by a richacl aware kernel, permissions
will be inconsistent.

> So why would this result in incompatible file systems?

The filesystems will not become incompatible in an e2fsck sense, but
it will generally become unsafe to expose in a multi-user environment.
So the question is what the different kinds of feature flags are
supposed to protect from exactly.

> For similar reasons we never had a feature flag for Posix ACL's.

Indeed, if you mount a filesystem that contains POSIX ACLs on a kernel
that doesn't support them, you can end up with the same kinds of
inconsistencies. Bad enough.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
