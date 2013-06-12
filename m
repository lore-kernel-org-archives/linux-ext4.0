From: Dave Hansen <dave@sr71.net>
Subject: Re: ext4 extent status tree LRU locking
Date: Wed, 12 Jun 2013 10:52:13 -0700
Message-ID: <51B8B54D.2040200@sr71.net>
References: <51B7B128.60909@intel.com> <20130612071735.GB29898@gmail.com> <51B88F1A.5000909@intel.com> <20130612160320.GA29156@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen@intel.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>,
	gnehzuil.liu@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130612160320.GA29156@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

FWIW, I'm also seeing this contention to a much smaller extent on much
more "normal" hardware.  I've got a 6-core (as opposed to 80) desktop
machine where I'm doing the same test on a real disk (instead of a
loopback-mounted ramfs file).

I'm seeing _about_ 10% CPU time being used on just spinning on the same
ext4 LRU lock.
