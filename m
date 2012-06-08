From: Phil Turmel <philip@turmel.org>
Subject: Re: Sync does not flush to disk!?
Date: Fri, 08 Jun 2012 09:49:01 -0400
Message-ID: <4FD202CD.7000309@turmel.org>
References: <4FD1CB8A.9080805@shiftmail.org> <20120608223332.5fe49193@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120608223332.5fe49193@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/08/2012 08:33 AM, NeilBrown wrote:
> On Fri, 08 Jun 2012 11:53:14 +0200 Asdo <asdo@shiftmail.org> wrote:
> 
>> Hello all
>> I don't exactly know where to ask this question...
>>
>> I have a situation of
>>
>> sda1 + sdb1 --> MD raid1
>> Above that is an ext4 filesystem. No LVM.
>>
>> I am making changes to that filesystem (vi a file) and then i am doing
>> sync
>> sync
>> (twice)
>>
>> then I am starting KVM in snapshot mode on the sda and sdb disks so to 
>> virtualize the same system on which I am operating.
>>
>> kvm -m 1024 -hda /dev/sda -hdb /dev/sdb -snapshot
>>
>> The strange thing is that the virtual machine is NOT seeing the latest 
>> changes to that file!
>>
>> Then I tried to do :
>>
>> for i in /dev/md? /dev/sda /dev/sdb ; do blockdev --flushbufs $i ; done
>>
>> and restart KVM,
>> and NOW it is seeing the changes.
>>
>> In the past I had similar problems, and not knowing about blockdev 
>> --flushbufs I ended up dismounting the filesystems and stopping the 
>> RAIDs. That also appeared to actually commit stuff to disk.

*Exactly*

>> So sync is not enough? Would somebody explain to me better?
> 
> There is a cache associated with /dev/sda and /dev/sdb which md does not make
> any use of.  The filesystem doesn't use it either.  It is only used from
> user-space reads from /dev/sda or /dev/sdb.
> When you "sync" the filesystem, the new data is written out, but the cache it
> not changes.  When you then read from /dev/sda, you might get cached data,
> which is stale.
> 
> blockdev --flushbufs
> clears that cache so that subsequent reads come from the device, not from the
> cache.
> 
> i.e. it is read caching that is causing the confusion you see, not write
> caching.

To put it another way:  You can't safely access ext filesystems via
raw devices in two systems.  The kernel cache won't be synchronized,
and you almost certainly *will* corrupt the contents.

You can unmount the FS then pass the raid to the VM, or dismantle the
raid as well, and let the VM assemble it.

There are cluster filesystems that allow multiple mounts of shared
devices, though.  I haven't played with them, so you might want to
do some googling.

Phil
