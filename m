From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Tool to view extent metadata
Date: Mon, 13 Jul 2009 10:28:54 -0500
Message-ID: <4A5B52B6.1060003@redhat.com>
References: <23904f640907091517w10608fa4y9b3b8b3a631217c@mail.gmail.com>	 <20090709225507.GH5073@webber.adilger.int> <23904f640907130803w20089c79md6f6ceef54ff8f8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Manuel Benitez <rickyb@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45628 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856AbZGMP3B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 11:29:01 -0400
In-Reply-To: <23904f640907130803w20089c79md6f6ceef54ff8f8e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Manuel Benitez wrote:
> Andreas,
> 
> Thank you for the reply. I wrote a program that uses FIEMAP to see
> what I could get from it. It gives the same information that you can
> extract from FIBMAP except that it is much more efficient (one ioctl
> call per extent rather than one call per block). Unfortunately, it
> does not give much insight into the structure of the metadata, so
> there is no way to tell how efficiently the metadata represents the
> file (depth of extent tree, number of internal and leaf nodes, etc.).

adding something to debugfs should not be hard either; look at how it
prints out the BLOCKS: when you stat a file, for extent-format files
it'd be nice to have a better representation.  If you wanted to write a
patch for this it'd be great.  :)

-Eric
