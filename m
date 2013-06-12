From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: xfstest ext4 'utility required' run stop
Date: Wed, 12 Jun 2013 14:31:32 +0800
Message-ID: <20130612063132.GA29898@gmail.com>
References: <20130612053618.296170@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmx.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47898 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3FLGNW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jun 2013 02:13:22 -0400
Received: by mail-pd0-f170.google.com with SMTP id x11so3739127pdj.1
        for <linux-ext4@vger.kernel.org>; Tue, 11 Jun 2013 23:13:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130612053618.296170@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 12, 2013 at 01:36:18AM -0400, jon ernst wrote:
> Hi,
> 
> When I try to run xfstest 301 - 304. They all got error message "utility required, run stop, stkip this test" , test 305 is fine.
> But it did not tell which utility is required. I do have test patition and scratch partition set up. And I do have e4defrag on my linux.
> 
> What could be the reason?please help.

Hi Jon,

Could you please check that 'fio' utility has been installed?  You can
get it from this link:
  git clone git://git.kernel.dk/fio.git

Regards,
                                                - Zheng
