From: "Burton, Ross" <ross.burton@intel.com>
Subject: Re: [PATCH] Fix up configure so it finds mkinstalldirs
Date: Thu, 10 Jul 2014 15:38:33 +0100
Message-ID: <CAJTo0LaOtnQAJrZTo+NK0KbnKtrcXUea6x-sRF8491-pQoqWsA@mail.gmail.com>
References: <1404965958-4793-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52634 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaGJOi4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 10:38:56 -0400
Received: by mail-qa0-f47.google.com with SMTP id i13so1981232qae.34
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 07:38:55 -0700 (PDT)
In-Reply-To: <1404965958-4793-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10 July 2014 05:19, Theodore Ts'o <tytso@mit.edu> wrote:
> As an object lesson in why autoreconf is fundamentally unsafe, the
> newer version of nls.m4 no longer handles @MKINSTALLDIRS@.  So add
> this back, since our Makefiles depend on it.

MKINSTALLDIRS is basically an implementation detail of the gettext
macros, it's best to add AC_PROG_MKDIR_P to configure.ac and use
$(MKDIR_P) instead.

I actually have a patch for this still from when I was removing all
generated files from git, I'll sent it to the list.

Ross
