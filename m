From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Beginner questions about ext4
Date: Wed, 10 Jul 2013 18:13:08 +0200
Message-ID: <CACyNnZPoAt2VNgGfRwzcvVdJHF8xKhE93zS7dGrmodg9Lm=cNQ@mail.gmail.com>
References: <loom.20130612T140739-743@post.gmane.org>
	<loom.20130623T082353-563@post.gmane.org>
	<20130623115953.GA16193@thunk.org>
	<CACyNnZNQ00D=hKHZ_wvfwJx3CWt7iELrbgUf_41AzzSAJmxGUw@mail.gmail.com>
	<20130701165524.GB23896@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64472 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab3GJQNJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jul 2013 12:13:09 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so6513843pdi.13
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jul 2013 09:13:08 -0700 (PDT)
In-Reply-To: <20130701165524.GB23896@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 1, 2013 at 6:55 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> I'm not sure whant you mean by "flexible groups".  There is no such
> concept.

This wiki says that flex_bg stands for "Flexible Block Groups":

https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Flexible_Block_Groups

>> If not, I wonder how a reader will recognize which groups were merged ...
>
> And block groups don't get merged.
>
> You should think of a flex block group as a collection of block
> groups.  (Just as a number of provinces make up country, or a
> collection of towns make up a county, and a number of counties make up
> a province.)

I'll try to be more specific.

When I am reading a ext4 file system and I find that there exists an
inode /etc/ with groupnr 32 and nodenr 260099, will this group 32 be
in the same position (distance in bytes from the beginning of the
disk) as in ext3? Or will the flex_bg make the first 16 groups fit
into the size that previously 1 group utilized? So group 32 in ext 4
would be in the physical position of group 2 in ext3.

If I have s_log_groups_per_flex=4 (seams the be the most popular
value), then each and every set of 16 groups will be groups into
flex_bgs or only some are grouped into flex_bgs?

Basically I have a reader for ext3 and I added EXTENT support and it
works now fine for the group 0, but for higher groups it is not
working and I'm trying to find out what I need to change ... I'm
trying to find what physically changed here... but it is a hard
battle. Much harder than EXTENT support was.

thanks,
-- 
Felipe Monteiro de Carvalho
