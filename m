From: david@lang.hm
Subject: Re: JBD: ext2online wants too many credits (744 > 256)
Date: Mon, 7 May 2007 07:46:38 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705070744350.18013@asgard.lang.hm>
References: <20070506222626.GA25632@janus> <20070507142736.GC17180@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Frank van Maarseveen <frankvm@frankvm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754469AbXEGOsj@vger.kernel.org>
In-Reply-To: <20070507142736.GC17180@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 7 May 2007, Theodore Tso wrote:

> We're going to have to rethink the defaults of the journal size as it
> relates to on-line resizing, but there might not be a lot of great
> answers here.  We'll also have to look at the on-line resizing code
> and see if there's a way to break up the resize operation into smaller
> transactions as a way of avoiding this problem --- but that would
> still leave the user stuck with a pathetically small 4M journal on a
> 3G filesystem.

why not just allocate a new journal (something along the lines of convert 
the ext3 to ext2 then back to ext3 would be the ugly, scripted way of 
doing it)

or is the problem that you are trying to resize things without remounting 
them (and therefor without flushing the journal)

David Lang
