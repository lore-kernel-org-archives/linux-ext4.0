From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] xfstest: fsstress should kill children tasks before exit
Date: Wed, 05 Oct 2011 17:41:13 +0400
Message-ID: <87zkhf369y.fsf@dmbot.sw.ru>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org> <1317820838.2226.11.camel@doink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: aelder@sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47940 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934769Ab1JENhD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Oct 2011 09:37:03 -0400
In-Reply-To: <1317820838.2226.11.camel@doink>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 5 Oct 2011 08:20:38 -0500, Alex Elder <aelder@sgi.com> wrote:
> On Sun, 2011-09-18 at 18:54 +0400, Dmitry Monakhov wrote:
> > It is very hard to predict runtime for fsstress. In many cases it
> > is useful to give test to run a reasonable time, and then kill it.
> > But currently there is no reliable way to kill test without leaving
> > running children.
> > This patch add sanity cleanup logic which looks follow:
> >  - On sigterm received by parent, it resend signal to it's children
> >  - Wait for each child to terminates
> >  - EXTRA_SANITY: Even if parent was killed by other signal, children
> >    will be terminated with SIGKILL to preven staled children.
> > 
> > So now one can simply run fsstress like this:
> > ./fsstress -p 1000 -n999999999 -d $TEST_DIR &
> > PID=$!
> > sleep 300
> > kill $PID
> > wait $PID
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> I think this is an interesting change and it looks
> OK to me.  I agree with Christoph's suggestion (on
> the second patch in this series) that it would be
> nice to have at least one of the tests make use of
> it, if nothing else just to document that it's a
> reasonable thing to do.
> 
> But even without that I think this is both useful
> and harmless.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
Ok i'll resend patch shortly, Actually test_case was explained inside
description. So far i've able to caught 3 different minor
fs-corruptions, one BUG_ON on ext4. And when i've run this test
on host with 24-cores it deadlock inside dcache core. 
> 
> 
