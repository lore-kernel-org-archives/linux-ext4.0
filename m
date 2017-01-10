From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: Refreshed rootfs.img for kvm-xfstests
Date: Tue, 10 Jan 2017 10:50:33 -0800
Message-ID: <20170110185033.GA58743@gmail.com>
References: <20170109231450.objek3yirxbtbgzn@thunk.org>
 <20170110033845.qkjg6qzfjxy5i54k@thunk.org>
 <CAJrWOzAebGpyLTJL2XsP8r4zjrbG030cLEXUVUK0t2sW8=g_Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: Roman Penyaev <roman.penyaev@profitbricks.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33128 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940227AbdAJSug (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jan 2017 13:50:36 -0500
Received: by mail-pf0-f195.google.com with SMTP id 127so30103529pfg.0
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jan 2017 10:50:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAJrWOzAebGpyLTJL2XsP8r4zjrbG030cLEXUVUK0t2sW8=g_Gg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 10, 2017 at 01:48:03PM +0100, Roman Penyaev wrote:
> 
> I retested the following configurations on 69973b830859 ("Linux 4.9"):
> 
> ./kvm-xfstests.sh -c nojournal    ext4/301
> ./kvm-xfstests.sh -c ext3conv     generic/347
> ./kvm-xfstests.sh -c adv          generic/396 generic/399
> ./kvm-xfstests.sh -c data_journal generic/347
> ./kvm-xfstests.sh -c bigalloc     generic/399
> ./kvm-xfstests.sh -c bigalloc_1k  generic/273
> 
> all of the tests from list have failed.
> 
> This is not very much helpful, but at least that can be a starting
> point for bisecting.
> 
> When there was a successful xfstests run at least for some of
> the configurations?  Would be nice to have a "good" reference.
> 

Hi Roman,

Generally these have been broken for a while, or in the case of generic/396 and
generic/399 are new tests which are exposing bugs.  A few of these I was already
aware of but just haven't had time to get to:

- the failure of generic/347 in data journalling mode is intermittent
- the failure of generic/396 in "adv" mode is related to the use of the inline
  data feature, apparently caused by ext4_convert_inline_data() corrupting an
  empty directory
- failure of generic/399 in some configurations

If you're interested in looking into any of these failing tests and either
fixing the kernel or fixing the test as appropriate, please feel free to!

Thanks,

Eric
