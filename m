From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Plans to evaluate the reliability and integrity of ext4 against
 power failures.
Date: Thu, 02 Jul 2009 07:21:28 -0400
Message-ID: <4A4C9838.7010006@redhat.com>
References: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com> <f3177b9e0907011107q17507be5icae2c1105faf4800@mail.gmail.com> <532480950907011131o7e9fc8bdn64002f130cc9615d@mail.gmail.com> <4A4BAEA2.6000101@redhat.com> <20090702021219.GA18372@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Michael Rubin <mrubin@google.com>,
	Chris Worley <worleys@gmail.com>,
	Shaozhi Ye <yeshao@google.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090702021219.GA18372@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/01/2009 10:12 PM, Jamie Lokier wrote:
> Ric Wheeler wrote:
>> One way to test this with reasonable, commodity hardware would be
>> something like the following:
>>
>> (1) Get an automated power kill setup to control your server
>
> etc.  Good plan.
>
> Another way to test the entire software stack, but not the physical
> disks, is to run the entire test using VMs, and simulate hard disk
> write caching and simulated power failure in the VM.  KVM would be a
> great candidate for that, as it runs VMs as ordinary processes and the
> disk I/O emulation is quite easy to modify.

Certainly, that could be useful to test some level of the stack. Historically, 
the biggest issues that I have run across have been focused on the volatile 
write cache on the storage targets.  Not only can it lose data that has been 
acked all the back to the host, it can also potentially reorder that data in 
challenging ways that will make file system recovery difficult....

>
> As most issues probably are software issues (kernel, filesystems, apps
> not calling fsync, or assuming barrierless O_DIRECT/O_DSYNC are
> sufficient, network fileserver protocols, etc.), it's surely worth a look.
>
> It could be much faster than the physical version too, in other words
> more complete testing of the software stack given available resources.
>
> With the ability to "fork" a running VM's state by snapshotting it and
> continuing, it would even be possible to simulate power failure cache
> loss scenarios at many points in the middle of a stress test, with the
> stress test continuing to run - no full reboot needed at every point.
> That way, maybe deliberate trace points could be placed in the
> software stack at places where power failure cache loss seems likely
> to cause a problem.
>
> -- Jamie

I do agree that this testing would also be very useful, especially so since you 
can do this almost in any environment.

Regards,

Ric

