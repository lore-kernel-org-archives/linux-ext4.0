From: Xupeng Yun <xupeng@xupeng.me>
Subject: Re: Bad performance of ext4 with kernel 3.0.17
Date: Sat, 3 Mar 2012 11:56:56 +0800
Message-ID: <CACaf2aZBMTgwqzkSXyeZ0uEt3s6BOh+4cTaTs3+vTb7bx_EJdw@mail.gmail.com>
References: <CACaf2aaqxM86DtdZMaaQZfrC+WbLwPjOVd=LmVjk+TvfObYUzQ@mail.gmail.com>
 <20120301194735.GD32588@thunk.org> <CACaf2aacsH-hd9YmXff+DX8qiDjNGeUv6kNe9JamPH6OpaN1Sw@mail.gmail.com>
 <20120302024531.GJ32588@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64903 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab2CCD5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2012 22:57:36 -0500
Received: by pbcun15 with SMTP id un15so797444pbc.19
        for <linux-ext4@vger.kernel.org>; Fri, 02 Mar 2012 19:57:36 -0800 (PST)
In-Reply-To: <20120302024531.GJ32588@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 2, 2012 at 10:45, Ted Ts'o <tytso@mit.edu> wrote:
> Hmm, it sounds like we're hitting some kind of scaling problem. =C2=A0=
How
> many CPU's/cores do you have on your server? =C2=A0And it would be
> interesting to try varying the --numjobs parameter and see how the
> various file systems behave with 1, 2, 4, 8, and 16 threads.

Oh, there are 8 physical cores with hyper-threading on the server.

--=20
Xupeng Yun
http://about.me/xupeng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
