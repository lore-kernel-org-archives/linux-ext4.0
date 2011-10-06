From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] [SIGNED-OFF] ext4: don't work without procfs
Date: Thu, 6 Oct 2011 12:44:06 -0400
Message-ID: <20111006164406.GC19049@thunk.org>
References: <1317916276-2509-1-git-send-email-yargil@free.fr>
 <1317916878.1823.2.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fabrice Jouhaud <yargil@free.fr>, linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1317916878.1823.2.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 06, 2011 at 09:01:18AM -0700, Joe Perches wrote:
> On Thu, 2011-10-06 at 17:51 +0200, Fabrice Jouhaud wrote:
> > From: Yargil <yargil@free.fr>
> 
> It would be better to use your full name on the "From: " line

In fact, in these cases I will normally copy the full name from
Signed-off-by to the From line before applying the patch.  (In general
the signed-off-by line and the From line should have the same contents.)

    		       	       	    	 - Ted

P.S.  Helpful tip: if you use emacs, try putting something like this
in your .emacs.el file:

(defun insert-signed-off-by ()
  (interactive)
  (insert "Signed-off-by: Fabrice Jouhaud" <yargil@free.fr>\n"))

(global-set-key "\^Cs" 'insert-signed-off-by)
