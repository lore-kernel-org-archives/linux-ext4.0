From: "Alexey Salmin" <alexey.salmin@gmail.com>
Subject: Maximum filename length
Date: Fri, 21 Nov 2008 18:51:23 +0600
Message-ID: <87a8dc10811210451p3ec1e3dar371a3ebffcedcdc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:46323 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbYKUMv0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 07:51:26 -0500
Received: by ug-out-1314.google.com with SMTP id 39so94171ugf.37
        for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 04:51:24 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello! I'm not sure the developers mailing list is a right place for
philosophical discussions - it's more about features, bugs and
patches. But anyway I have an important for me topic I want to talk
about.
Limits of the ext4 file are really huge, I just can't imagine 1 EiB
disk array, it's out of my mind's bounds. Maximum file size is quite
big too. But there is one limitation looking tiny against these Tera-
and Exbi-bytes: maximum filename length is 255 bytes. Is 255
characters enough? I think it's enough for the vast majority of users.
But there is one problem: 255 bytes and 255 characters are no longer
equal. Multibyte encodings are spreading fast and it should be taken
into account. For a long time I was using the simple koi8-r encoding
and it was enough. Even when my favorite debian distribution moved to
utf8 I was still keeping it. Even when I discovered that gtk and qt
application always use utf8 and every io-operation causes conversions
I was using koi8. But when I found out that the first thing gcc does
with the source code is converting it to utf8 I thought that it is
really the time to move ahead. I was full of optimism converting my
file systems to utf8 but I discovered that my book collection can not
be stored correctly due to the 127 characters filename length
limitation. Actually I'm lucky having only two bytes per character,
utf8-character can contain up to 4 bytes which reduces the limit to 63
characters. Really I see no reasons for keeping such a terrible
limitation. Ext4 branch was created because there were to many things
to change compared to ext3. And it's very sad that such a simple
improvement was forgotten :(

Alexey
