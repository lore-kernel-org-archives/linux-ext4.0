From: Zach Brown <zab@zabbo.net>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 13:37:07 -0400
Message-ID: <4F60D743.50209@zabbo.net>
References: <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com> <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com> <20120310044804.GB5652@thunk.org> <4F5F9A97.5060404@ubuntu.com> <20120313195339.GA24124@thunk.org> <4F5FAC9C.9070607@gmail.com> <20120313213304.GB11969@thunk.org> <CAGBYx2ZQk+kobPj5ff0NKEfK_-kD0NK4WiNUruF=d443PV-NSw@mail.gmail.com> <20120314025108.GF15379@thunk.org> <4F60A881.3070607@zabbo.net> <20120314164804.GA28042@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Phillip Susi <phillsusi@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120314164804.GA28042@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/14/2012 12:48 PM, Ted Ts'o wrote:
> On Wed, Mar 14, 2012 at 10:17:37AM -0400, Zach Brown wrote:
>>
>>> We could do this if we have two b-trees, one indexed by filename and
>>> one indexed by inode number, which is what JFS (and I believe btrfs)
>>> does.
>>
>> Typically the inode number of the destination inode isn't used to index
>> entries for a readdir tree because of (wait for it) hard links.  You end
>> up right back where you started with multiple entries per key.
>
> One thing that might work is to have a 16-bit extra field in the
> directory entry that gives an signed offset to the inode number so
> that such that inode+offset is a unique value within the btree sorted
> by inode+offset number.  Since this tree is only used for returning
> entries in an optimal (or as close to optimal as can be arranged)
> order, we could get away with that.

Yeah, at least that's nice and simple.  Personally, I'm always nervous
when we build in new limits like this.  Some joker somewhere always
manages to push up against them.

But such is life.  Maybe it's the right thing in the ext* design space.
The fixed number of possible inodes certainly makes it easier to pack
more inode offsets into the telldir cookie.

- z
