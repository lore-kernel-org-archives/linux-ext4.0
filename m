From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [LSF/MM TOPIC] Use generic FS in virtual environments challenges and solutions
Date: Wed, 29 Jan 2014 18:32:58 +0400
Message-ID: <87zjmekgdh.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Pavel Emelianov <xemul@parallels.com>,
	Konstantin Khorenko <khorenko@parallels.com>
To: lsf-pc@lists.linux-foundation.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Number of virtual environment/container solutions are grow rapidly, here is just
small list of well known names (qemu/kvm, VMware, openvz, LXC, etc)
There are two main challenges any VE solution should overcome:
1) Minimize Guest OS modification (ideally run unmodified binaries)
2) Resource sharing between several VE contexts (mem,cpu,disk)
There are plenty of advanced algorithms for CPU and memory sharing
between VEs. There are no many effective virtualization schemes for
disk at the moment.

OpenVZ project has interesting experience in fs/disk virtualization.
I want to propose three topics about fs/disk virtualization:

1) Effective space allocation scheme aka "Thin provision" [1]
   Generic filesystem tries to spawn all it's data across whole disk.
   In case of virtual images this result continuous VImage growth
   during FS activity even if actual FS disk usage is low.

   We have done some research and modified ext4 block allocator
   which allow us to reduce VImage swelling effect, I would like to
   discuss our finding's.

2) Space reclamation FS/disk shrinking
   FS/disk growth is relatively simple operation most disk images and FS allow
   online grow [2], but shrink is very heavyweight operation. I would like
   to discuss some tricks how to make offline/online shrink less intrusive.

3) Filesystem error detection and correction
   At this moment most filesystem may detect internal errors and perform
   basic actions(panic,remount_ro) but this reaction is not suitable
   for virtual environment because HardwareNode should continue to
   operate and fix dedicated VE as soon as possible.
   For this purpose it is reasonable to:
   A) Implement fs event notification API similar to UEVENTs for devices or
      quota event API. I would like to discuss this API.
   B) Reduce fsck time. Theodore Tso have announced initiative to implement
      ffck for ext4 [3]. I want to discuss perspectives of design and
      implementation online fsck for ext4.

Footnotes: 
[1]  http://en.wikipedia.org/wiki/Thin_provisioning

[2]  http://openvz.org/Ploop

[3]  http://marc.info/?l=linux-ext4&m=138661211607779&w=2

