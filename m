From: Mark Lord <kernel@teksavvy.com>
Subject: Re: GIT PULL] ext4 updates for 3.5
Date: Fri, 01 Jun 2012 12:45:27 -0400
Message-ID: <4FC8F1A7.2060208@teksavvy.com>
References: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 12-06-01 11:07 AM, Theodore Ts'o wrote:
> Ext4 updates for 3.5
> 
> The major new feature added in this update is Darrick J. Wong's
> metadata checksum feature, which adds crc32 checksums to ext4's
> metadata fields.  There is also the usual set of cleanups and bug
> fixes.

That sounds vaguely like an on-disk change that may have issues
with systems that regularly switch between older and newer kernel versions.

Could you elaborate on it a bit more, thanks!
