From: Kamran Khan <krkhan@inspirated.com>
Subject: Re: Difference in jbd2 behavior between CentOS and Ubuntu while unmounting
Date: Wed, 18 May 2016 12:01:43 -0700
Message-ID: <CAN0j2-duVA45Vr40rza-PLcwhx6z+KHAGT9Wj+dCGWwwmp9qdQ@mail.gmail.com>
References: <CAN0j2-ek1iJ_a8ii+sg+kTdjcmZD6jVUHO9SJBbbhfD+5s_CGw@mail.gmail.com>
	<32a9cbf4-4e2d-335c-0603-9639b30e2863@redhat.com>
	<CAN0j2-cp1odcT44ZoeFDGHMF519F2b9Ffa5vc8PJyJfSLcj5-Q@mail.gmail.com>
	<782fe069-c14f-4bae-609e-bbad554cb657@redhat.com>
	<20160518061834.GA4502@birch.djwong.org>
	<20160518141240.GB1710@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:34918 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbcERTBo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2016 15:01:44 -0400
Received: by mail-vk0-f51.google.com with SMTP id f66so73934333vkh.2
        for <linux-ext4@vger.kernel.org>; Wed, 18 May 2016 12:01:44 -0700 (PDT)
In-Reply-To: <20160518141240.GB1710@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2016 at 7:12 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Try the following to see if someone process is playing namespace games
>
> find /proc -name mounts | xargs grep /dev/sda3
>
> (replace /dev/sda3 with the device that you think is unmounted).
>
> When you find the process, kill it.  (Or try doing a service XXX
> restart assuming that the device has been unmounted in the "normal"
> mount namespace.)

That did the trick! systemd-udevd was the culprit. Somehow it wasn't
appearing in lsof/fuser outputs but had the block device listed in its
mounts.

Killed it and the block device was released for further operations.

Thanks!!
-- 
Kamran.

http://inspirated.com/
