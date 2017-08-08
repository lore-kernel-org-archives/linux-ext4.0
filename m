From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: How to enable CONFIG_EXT4_ENCRYPTION
Date: Mon, 7 Aug 2017 22:50:13 -0700
Message-ID: <20170808055013.GA593@zzz.localdomain>
References: <20170807032502.2tiyjybtqrn6odab@linux>
 <20170807095126.hyhrrnr4vrj3ne4k@linux>
 <20170807134942.u3ep5ivfq4ublueb@thunk.org>
 <20170807193138.GA46084@gmail.com>
 <20170808012738.6rlknzovmyhjn4rg@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Dai Xiang <xiangx.dai@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35337 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdHHFuR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Aug 2017 01:50:17 -0400
Received: by mail-pg0-f67.google.com with SMTP id l64so2137355pge.2
        for <linux-ext4@vger.kernel.org>; Mon, 07 Aug 2017 22:50:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170808012738.6rlknzovmyhjn4rg@linux>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 08, 2017 at 09:27:38AM +0800, Dai Xiang wrote:
> > 
> > Actually, this is one of the tests in the "encrypt" group, which format the
> > scratch device with "-O encrypt".  So I believe the printed message is correct.
> > Are you 100% sure that CONFIG_EXT4_ENCRYPTION is enabled in your kernel config
> > and that you are running the correct kernel?
> 
> I use v4.13-rc3 kernerl, and i find this info refer to https://wiki.archlinux.org/index.php/ext4#Using_file-based_encryption:
> 
> Ext4 forbids encrypting the root (/) directory and will produce an error on kernel 4.13 and later
> 
> Does it impact?
> 

No, the tests do not try to encrypt the root directory.  Can you please double
check that the kernel you're testing actually has CONFIG_EXT4_ENCRYPTION
enabled?

Eric
