From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Need to potentially watch stack usage for ext4 and AIO...
Date: Fri, 19 Jun 2009 20:46:12 -0500
Message-ID: <4A3C3F64.70007@redhat.com>
References: <E1MHiN1-0002TX-Cu@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZFTBqL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jun 2009 21:46:11 -0400
In-Reply-To: <E1MHiN1-0002TX-Cu@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> On a 32-bit system, while running aio-stress, I got the following kernel
> message:
> 
> aio-stress used greatest stack depth: 372 bytes left
> 
> That's a bit close for comfort; we may want to see if we have some
> especially piggy on-stack allocations on the AIO code paths.
> 
> 	   	 	  	      	     - Ted

Ted, you might try the built-in stack depth tracing stuff:

config STACK_TRACER
        bool "Trace max stack"
        depends on HAVE_FUNCTION_TRACER
        select FUNCTION_TRACER
        select STACKTRACE
        select KALLSYMS
        help
          This special tracer records the maximum stack footprint of the
          kernel and displays it in debugfs/tracing/stack_trace.

          This tracer works by hooking into every function call that the
          kernel executes, and keeping a maximum stack depth value and
          stack-trace saved.  If this is configured with DYNAMIC_FTRACE
          then it will not have any overhead while the stack tracer
          is disabled.

          To enable the stack tracer on bootup, pass in 'stacktrace'
          on the kernel command line.

          The stack tracer can also be enabled or disabled via the
          sysctl kernel.stack_tracer_enabled

          Say N if unsure.

if you got within 372 bytes on 32-bit (with 8k stacks) then that's
indeed pretty worrisome.

-Eric
