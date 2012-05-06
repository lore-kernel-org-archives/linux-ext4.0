From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Announcing the Berserker toolkit for (semi-)automated fs fuzz
 testing
Date: Sun, 6 May 2012 11:27:27 +0100
Message-ID: <20120506102727.GA11619@amd.home.annexia.org>
References: <20120428013904.GE20648@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab2EFK13 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 May 2012 06:27:29 -0400
Content-Disposition: inline
In-Reply-To: <20120428013904.GE20648@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 28, 2012 at 04:39:04AM +0300, Sami Liedes wrote:
> This is an announcement of the first release of the Berserker toolkit
> for (semi-)automated fuzz testing and testcase minimization of Linux
> kernel filesystem implementations.

This looks interesting, and it's very necessary to find these bugs in
filesystem drivers to improve the security around virtualization and
untrusted disk images.

I wrote something similar a while back, trying to use systemtap to do
feedback-directed fuzz testing.  By putting a tracepoint on every line
in the filesystem module, you can find out how many lines of code are
actually executed when mounting/using the fuzzed filesystem and use
that as a cost function for feedback (maximizing the # of lines
executed, rather than blindly fuzzing).  Unfortunately it doesn't work
yet because of a bug in Linux[1].

Anyway I was going to say: why not use libguestfs to provide a simpler
framework for running KVM and the fuzzer?

Rich.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=713248

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://et.redhat.com/~rjones/virt-top
