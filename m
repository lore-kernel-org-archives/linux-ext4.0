From: Peter Moody <pmoody@google.com>
Subject: Re: Oops with ext(3|4) and audit and Xen
Date: Mon, 8 Oct 2012 14:19:05 -0700
Message-ID: <CALnj_=70B2O9RuNEnb3irsvNbaxrAD1GevYRdU0zw6c8=g1Syw@mail.gmail.com>
References: <CALnj_=5eQ5vCmv8x3u-rJPzofqJr+WDJuYzkpZo8sLe0+B2AAw@mail.gmail.com>
 <20121008211500.GD22980@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53434 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2JHVTh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 17:19:37 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so4500734wib.1
        for <linux-ext4@vger.kernel.org>; Mon, 08 Oct 2012 14:19:36 -0700 (PDT)
In-Reply-To: <20121008211500.GD22980@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 8, 2012 at 2:15 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Oct 08, 2012 at 11:19:53AM -0700, Peter Moody wrote:
>>
>> I'm trying to track down a BUG() that seems to strike a particular
>> system configuration (unfortunately, an increasingly common
>> configuration), but does so with 100% reliability.
>
> Peter, this looks like exactly the same issue that you asked me about
> back in July, isn't it?  Check your corp e-mail archives for the
> subject line: "advice/pointers on debugging a potential kernel race".
>
> As I recall, the problem was a missing path_put() in audit_putname()
> in kernel/auditsc.c?
>
>                                         - Ted

Yep, this is that issue and I thought that was the fix but it turns
out it wasn't. The dentry was already being pinned in:

if (!context->pwd.dentry)
  get_fs_pwd(current->fs, &context->pwd);

so my path_get/path_put patch just needlessly grabbed a second reference.

-- 
Peter Moody      Google    1.650.253.7306
Security Engineer  pgp:0xC3410038
