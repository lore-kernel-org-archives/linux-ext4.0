From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 09:57:23 +0100
Message-ID: <4F684673.1050309@suse.cz>
References: <cover.1331856299.git.joe@perches.com>  <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>  <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>  <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jiri Slaby <jirislaby@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332176943.1983.28.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/19/2012 06:09 PM, Joe Perches wrote:
> On Mon, 2012-03-19 at 17:46 +0100, Jiri Slaby wrote:
>> On 03/19/2012 05:25 AM, Joe Perches wrote:
>>> On Mon, 2012-03-19 at 00:09 -0400, Ted Ts'o wrote:
>>>> One evidence that this patch is noise is that it doesn't apply cleanly
>>>> just on top of my current patch set that I plan to send to Linus.
>>> It's more evident that you don't make
>>> public your own internal patch queue
>>> quickly enough than anything else.
>> Please stop repeating that shit. I already explained you the reasons. A
>> couple of weeks ago.
...
> As far as I can tell, your "reasons" as you
> explained it is that you just do not like
> whitespace or style changes.

No, sorry, you misunderstand me. Here, I meant your complain that we are
not fast enough with pushing patches. Some of us simply do not push
patches as soon as they are written. I personally prefer deferring
patches for some time (weeks) to actually give some testing to the
changes. Simply because I have bad experiences with patches emerging in
the (-next) tree immediately. (And I mean not only my patches.)

While you are pointing to whitespace cleanup of whole subtrees. Yes, I
wrote about _whitespace_ cleanup in the thread you are referring to. But
this can be generalized to an arbitrary cleanup. I.e. changes which do
not change functionality in no way. And that is doubtful with pr_*
changes. But as you can see in my post a couple of minutes ago, maybe I
am just missing the point of the new interface. (And I hate naming of
the pr_* functions.)

And BTW setting the argument that it is a newer interface (that is what
ath5k pr_* conversion patches commit log says) is not a good
justification at all.

thanks,
-- 
js
suse labs
