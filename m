From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Sun, 18 Aug 2013 08:04:20 +0200
Message-ID: <CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
	<CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
	<20130817130204.GA30769@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37007 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3HRGEV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Aug 2013 02:04:21 -0400
Received: by mail-pb0-f44.google.com with SMTP id xa7so3600376pbc.31
        for <linux-ext4@vger.kernel.org>; Sat, 17 Aug 2013 23:04:20 -0700 (PDT)
In-Reply-To: <20130817130204.GA30769@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 17, 2013 at 3:02 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> I think part of the problem (besids lots of people being busy and on
> vacation) is it's not clear what your ext4 reader is going to be used
> for.  As a result it's hard to give advice, not knowing what the
> requirements are for said reader.

I think that I formulated my question incorrectly. I did not mean
"please give me advice over my specific application" this time, but
rather what I wanted was "please tell me a little about these various
features and also tell me if they are finished or still work in
progress, etc". Which is precisely what you answered already, so
thanks a lot =)

> These features aren't quite fully supported yet.  The inline data
> feature is probably closest to be being fully supported, when we
> release an the next major version of e2fsprogs.

Just for completeness, which version number will that by?

So, I understand that currently mkfs.ext4 cannot generate ext4 file
systems with this feature, correct?

Is there any other way to generate a file system with this feature
with a 3.8 kernel which will work?

Just wondering if I can already start work on this or if I need to wait.

thanks,
-- 
Felipe Monteiro de Carvalho
