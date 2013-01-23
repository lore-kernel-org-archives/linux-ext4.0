From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH 1/3] contrib: add safe_getenv() support to spd_readdir
Date: Wed, 23 Jan 2013 13:17:25 +0100
Message-ID: <87d2ww8562.fsf@mid.deneb.enyo.de>
References: <1358813390-26466-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ka.mail.enyo.de ([87.106.162.201]:60980 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649Ab3AWMsH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2013 07:48:07 -0500
In-Reply-To: <1358813390-26466-1-git-send-email-tytso@mit.edu> (Theodore
	Ts'o's message of "Mon, 21 Jan 2013 19:09:48 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o:

> +#if HAVE___SECURE_GETENV
> +	return __secure_getenv(arg);
> +#else
> +	return getenv(arg);
> +#endif

glibc 2.17 has secure_getenv, but not __secure_getenv.  Unfortuantely,
this was the only way to turn this into an official interface.
