From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: My current version of the inline data patches
Date: Tue, 21 May 2013 12:01:56 +0800
Message-ID: <20130521040156.GC23907@gmail.com>
References: <1367059481-6090-1-git-send-email-wenqing.lz@taobao.com>
 <20130521023636.GA586@thunk.org>
 <20130521031144.GA23907@gmail.com>
 <20130521032657.GB586@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63036 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3EUDoE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 May 2013 23:44:04 -0400
Received: by mail-pb0-f49.google.com with SMTP id rp8so168618pbb.8
        for <linux-ext4@vger.kernel.org>; Mon, 20 May 2013 20:44:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130521032657.GB586@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 20, 2013 at 11:26:57PM -0400, Theodore Ts'o wrote:
> The inlinie data patches, which have been updated to the latest master
> branch, can be found here:
> 
> https://github.com/tytso/e2fsprogs-inline-patch-queue
> 
> or
> 
> git://github.com/tytso/e2fsprogs-inline-patch-queue.git
> 
> 
> You can look at the history if you want to see what I've done.  The
> main thing to note is that while we are maintaining patches in a patch
> series, and while we are still trying to clean up the function
> interfaces, to fold any changes into parent patches.
> 
> So for example, I've folded all of the gcc -Wall cleanups that had
> been in "libext2fs-fix-some-warnings-from-gcc-Wall" into the patches
> that introduced the gcc warnings.  This makes it easier to review the
> patches, since we don't have the problem of a patch which has bugs or
> warnings which is fixed in a later patch.
> 
> When I did that, I found a change which was not related to gcc -Wall
> cleanups hiding in that patch.
> 
> I think I remember seeing other places where unrelated changes were
> glommed together into a single patch.  As we find them, we should
> split them into separate patches, again for ease of patch maintenance
> and improvements.
> 
> Again, my apologies for taking so long in getting these patches out
> there.  I really wanted to give you some examples in the kind of patch
> factoring and interface cleanups that I was hoping for before merging
> this support upstream.  Unfortuantely, I've been crazy busy these last
> few weeks.  I had hoped to put more work into this today, but I lost
> at least two hours due to a burst gas main which forced the
> evacuations of the offices.  :-(
> 
> (Turns out it's not just network fibers which emit backhoe pheromones,
> gas mains do as well.  :-)
> 
> I'll let you take the next whack at improving the patches.  My
> suggestion is that you create your own github repository, and update
> the patches using git.  What I generally do is to apply the patches
> using guilt (I suggest using v0.35 from git://repo.or.cz/guilt.git) by
> pulling down the github repository into an e2fsprogs repository at
> ".git/patches/inline".  Then take a look at first line of
> .git/patches/inline/series, which currently reads:
> 
> # BASE 4cf7a7014a209b82aada9b5d83ecdb9b07e60a1a
> 
> In the top of the e2fsprogs repository, type the commands:
> 
> % pushd .git/patches/inline ; sh timestamps ; popd
> % git branch inline 4cf7a7014a209b82aada9b5d83ecdb9b07e60a1a
> % git checkout inline
> % guilt push -a
> 
> This will apply all of the patches in .git/patches/inline (which you
> pulled down from github) to the e2fsprogs tree.  You can go back and
> forth by using the commands "guilt pop" and "guilt push".  To modify a
> patch, just edit the e2fsprogs files, and then use the command "guilt
> refresh --diffstat" to merge your edits into the patch file.  You can
> then commit changes to the patch queue by cd'ing into
> .git/patches/inline directory, and running standard "git commit"
> commands.  This way, when you send me an updated set of patches, I can
> look at the git log to see what changes you've made.
> 
> Does this make sense?  If not, please feel free to send me any
> questions you have.

Hi Ted,

Definitely it makes sense to me.  I really appreciate and thank you
for your suggestion.  Yes, I have used guilt to manage my patches for
a long time.  That is really useful for me.  I will revise every
single commit, and improve them.

Thanks,
                                                - Zheng
