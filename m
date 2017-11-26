From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Sun, 26 Nov 2017 22:35:08 +0100
Message-ID: <6644604d-b7b3-d836-927d-1bfecc3fa6eb@thelounge.net>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
 <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
 <20171125223202.GL4094@dastard> <20171126154026.2cyhh3vsvhnszhvs@thunk.org>
 <20171126211427.GO4094@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.thelounge.net ([91.118.73.15]:42043 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdKZVfK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Nov 2017 16:35:10 -0500
In-Reply-To: <20171126211427.GO4094@dastard>
Content-Language: de-CH
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Am 26.11.2017 um 22:14 schrieb Dave Chinner:
> On Sun, Nov 26, 2017 at 10:40:26AM -0500, Theodore Ts'o wrote:
>> Are you
>> running some benchmarks that are logging into the root, and that's
>> triggering the ENOSPC condition?
> 
> No, I'm not doing anything like that on these machines. It's
> straight forward "something filled the root fs unexpectedly" type of
> error which I don't notice immediately...

have you ever considered to just buy larger disks or introduce quota 
because "Unlike ext3, ext4 is not a filesystem that takes kindly to 
being abused by an environment that involves machines being crashed, 
oopsed and forcibly rebooted without warning tens of times a day" caused 
by a full root fs is anyhting but a reasonable workload and i doubt any 
filesystem is intended to run under such abused environment

it would be even enough to not run that workload as root because that's 
the reserved diskspace is for
