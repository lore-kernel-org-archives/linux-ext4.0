From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Mon, 31 Aug 2015 18:23:01 -0600
Message-ID: <4D95B36D-5AB6-4CF6-8BCA-03E0562F3ED3@dilger.ca>
References: <20150831061920.GA2751@quack.suse.cz> <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 31, 2015, at 3:37 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> On Sun, Aug 30, 2015 at 11:19 PM, Jan Kara <jack@suse.cz> wrote:
>> 
>> The biggest change in the pull is the removal of ext3 filesystem driver
>> (~28k lines removed).
> 
> I really am not ready to just remove ext3 without a lot of good
> arguments. There might well be people who this use ext3 as ext3, and
> don't want to update. I want more a rationale for removal than "ext4
> can read old ext3 filesystems".

The ext4 code can read and write ext3 filesystems without any
compatibility issues (i.e. none of the ext4-specific features are
enabled automatically) and have been doing so for all RHEL and SLES
users for the past several years via the CONFIG_EXT4_USE_FOR_EXT23
option (added in commit 24b58424 in 2009).  It looks like the same
for Ubuntu since early 2014 also.

The ext4-specific features either need to be enabled specifically
via tune2fs (if possible) or at mkfs time.

Cheers, Andreas
