From: "Eric A" <erpo41@gmail.com>
Subject: Fwd: barriers off by default?
Date: Mon, 12 May 2008 12:51:09 -0600
Message-ID: <72c5d9a0805121151m2d838f3cxe61368b928dc5db2@mail.gmail.com>
References: <482868A5.1000102@redhat.com>
	 <72c5d9a0805121030y709de9cehc01df8aeb5b1b8d3@mail.gmail.com>
	 <482883FD.8060001@redhat.com>
	 <72c5d9a0805121150j58482bc6qd57a87089ce4414e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:9620 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYELSvL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 14:51:11 -0400
Received: by mu-out-0910.google.com with SMTP id w8so1268513mue.1
        for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 11:51:10 -0700 (PDT)
In-Reply-To: <72c5d9a0805121150j58482bc6qd57a87089ce4414e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Whoops. Forgot to send this to the list.


---------- Forwarded message ----------
From: Eric A <erpo41@gmail.com>
Date: Mon, May 12, 2008 at 12:50 PM
Subject: Re: barriers off by default?
To: Eric Sandeen <sandeen@redhat.com>


On Mon, May 12, 2008 at 11:53 AM, Eric Sandeen <sandeen@redhat.com> wrote:
 >  > From reading the documentation, I was under the impression that write
 >  > barriers don't always do what they're supposed to do.
 >
 >  Which documentation?
 >

 Documentation/block/barrier.txt

 There's a section that starts:

 "* Error handling.  Currently, block layer will report error to upper
 layer if any of requests in an ordered sequence fails.  Unfortunately,
 this doesn't seem to be enough. "

 Cheers,
 Eric
