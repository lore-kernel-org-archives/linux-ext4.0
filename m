From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: ext4_bread usage audit
Date: Tue, 25 Sep 2012 22:48:17 -0500
Message-ID: <50627B01.6070306@redhat.com>
References: <1348512100-23323-1-git-send-email-cmaiolino@redhat.com> <20120926034240.GE11468@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2IZDsX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2012 23:48:23 -0400
In-Reply-To: <20120926034240.GE11468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/25/12 10:42 PM, Theodore Ts'o wrote:
> On Mon, Sep 24, 2012 at 03:41:40PM -0300, Carlos Maiolino wrote:
>>
>> Some ext4_bread callers do not needed any changes either because they already
>> had its own hole detector paths or because these are deprecaded (like
>> dx_show_entries)
> 
> BTW, dx_show entries isn't really deprecated; is debugging code which
> is usually not compiled in, but it does get used from time to time by
> developers who are debugging the directory hash tree code...
> 
> So having it show the holes by printing a note that there _was_ a
> whole is probably a good thing from a debugging point of view...

I think what Carlos meant is that there are no callers in the tree...
so even with debug options, it's not used.  It takes a custom patch...
Does it still work? :)

-Eric

>       	 	    	       - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

