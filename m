From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
Date: Thu, 26 Jun 2014 12:24:50 -0400
Message-ID: <20140626162450.GD6826@thunk.org>
References: <1403192228-25771-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403192228-25771-1-git-send-email-lczerner@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I like the performance improvement of your patch, but I'm concerned
that it might be a bit too complicated to push outside of the merge
window.

So what I propose doing is this.  We'll take Jan's patches and after
testing, we'll push it to Linus.  Then for the the 3.17 merge window,
after we've had more opportunity for testing and for other folks to
review your changes, we can queue this patch (or its successor).

Does that seem like a good path forward?

						- Ted
