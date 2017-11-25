From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Sat, 25 Nov 2017 23:45:07 +0100
Message-ID: <d5020ffd-a174-8a57-5b0f-1b6424e74467@thelounge.net>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
 <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
 <20171125223202.GL4094@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Ts'o <tytso@mit.edu>,
        Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>,
        Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171125223202.GL4094@dastard>
Content-Language: de-CH
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Am 25.11.2017 um 23:32 schrieb Dave Chinner:
> On Fri, Nov 24, 2017 at 03:03:37PM -0700, Andreas Dilger wrote:
>> Any worse an idea than running a new kernel on an old system?
>> Newer e2fsck fixes a lot of bugs that are present in older
>> e2fsck as well...
> 
> I'm running with everything up to date (debian unstable) on these
> VMs, they are just an old filesystem because some distros have had
> reliable rolling updates for the entire life of these VMs. :P

but why not update the FS to ext4?

our whole infrastructure was installed with Fedora 9 on ext3 (currently 
running F26, yum/dnf dist-upgrades) but any FS including the rootfs was 
converted to ext4 in 2010
