From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 20:02:54 -0700
Message-ID: <1332212574.7847.49.camel@joe2Laptop>
References: <20120319153133.GA2502@thunk.org>
	 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
	 <20120319161425.GB2502@thunk.org>
	 <20120319.141402.934377752041508724.davem@davemloft.net>
	 <20120319183126.GA6031@thunk.org> <1332182773.3908.11.camel@joe2Laptop>
	 <20120320010401.GA14363@thunk.org> <1332207202.7847.23.camel@joe2Laptop>
	 <20120320014707.GD14363@thunk.org> <1332208741.7847.46.camel@joe2Laptop>
	 <20120320025835.GE14363@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:36969 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754680Ab2CTDC4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 23:02:56 -0400
In-Reply-To: <20120320025835.GE14363@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2012-03-19 at 22:58 -0400, Ted Ts'o wrote:

[good stuff]

> Of course, the body of the message needs to be standardized too.  But
> that's orthogonal to the problem of passing the kernel structure which
> identifies the object which the log message is about.  That part is
> completely and utterly necessary if you're going to standardize the
> *first* part of the printable dmesg log, which contains the structured
> information.

All of what you say is true, but you're neglecting
the ability to scrape or notify a particular set of
per subsystem messages that pr_<level> could easily
provide that a bare printk could not.


