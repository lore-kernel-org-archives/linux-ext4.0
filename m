From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/9 linux-next] move dir_pages() to pagemap.h
Date: Fri, 5 Jun 2015 15:43:44 +0100
Message-ID: <20150605144344.GU7232@ZenIV.linux.org.uk>
References: <1432480791-31396-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, osd-dev@open-osd.org,
	linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432480791-31396-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 24, 2015 at 05:19:40PM +0200, Fabian Frederick wrote:
> This small patchset declares dir_pages() in pagemap.h and
> removes declarations in each filesystems.

Applied, with #2 and #4--9 folded into #1 - otherwise you get build breakage.
