From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: hole punching in ext4
Date: Wed, 23 Jan 2013 00:20:09 +0800
Message-ID: <20130122162009.GB2072@gmail.com>
References: <CAKSyJXfvTFjGMO2ZZPsnSjc_fnUzfs2oMrYf7UQoPvO0=98FxA@mail.gmail.com>
 <CAKSyJXdbwtOQi==rPZ3nS72bLb9wd0rrmt8RTNPJMUCph-B1Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Bradley C. Kuszmaul" <kuszmaul@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:54073 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3AVQGP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2013 11:06:15 -0500
Received: by mail-da0-f45.google.com with SMTP id w4so3309265dam.32
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 08:06:14 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAKSyJXdbwtOQi==rPZ3nS72bLb9wd0rrmt8RTNPJMUCph-B1Ow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 22, 2013 at 09:34:59AM -0500, Bradley C. Kuszmaul wrote:
> Hi,
> 
> Do any of the ext file systems support hole punching?  If so, do the
> redhat distributions support it?  Can someone provide an example of a
> program that punches a hole in a file in an ext4 file system?

Hello,

Ext4 file system supports hole punching.  But until now only extent-based
file supports it.  As far as I know, redhat distributions don't support
hole punching.  You can find a sample program from e2fsprogs which is in
$e2fsprogs/conrib/fallocate.c.  The latest fallocate(1) in util-linux
also can be as a demo.

Regards,
                                                - Zheng
