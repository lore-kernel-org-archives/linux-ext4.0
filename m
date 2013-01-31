From: Aditya Kali <adityakali@google.com>
Subject: Re: how to quotacheck with the new quota implementation (hidden inode)?
Date: Thu, 31 Jan 2013 11:04:48 -0800
Message-ID: <CAGr1F2F=mffm7PORykm2CbXt3EWt1=Zgerw-OEy7oGzUQ2dEQA@mail.gmail.com>
References: <20730.1955.395545.141779@fisica.ufpr.br> <20130121054741.GB321@thunk.org>
 <20746.49010.569691.44452@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:60855 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3AaTFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2013 14:05:09 -0500
Received: by mail-ia0-f171.google.com with SMTP id z13so4303413iaz.2
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2013 11:05:09 -0800 (PST)
In-Reply-To: <20746.49010.569691.44452@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

By default, only usage is enabled when the filesystem is mounted. You
will need to call quotaon to turn on limit enforcement. If it doesn't
even after that, then its a bug.

On Thu, Jan 31, 2013 at 11:01 AM, Carlos Carvalho <carlos@fisica.ufpr.br> wrote:
> I've just seen that the new quota implementation doesn't stop writes
> after the limit has been reached. This means it's useless... The
> machine is running 3.7.3.
>
> To check: dd if=/dev/zero of=anything bs=2M
>
> It'll never stop. I've gone over twice my limit to be sure.



-- 

Aditya
