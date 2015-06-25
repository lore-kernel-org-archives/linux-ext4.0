From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [GIT PULL] ext4 changes for 4.2-rc1
Date: Thu, 25 Jun 2015 15:37:14 +0000 (UTC)
Message-ID: <pan.2015.06.25.15.37.14@googlemail.com>
References: <20150625034626.GA21682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 24 Jun 2015 23:46:26 -0400, Theodore Ts'o wrote:

>   ext4: set lazytime on remount if MS_LAZYTIME is set by mount

I was wondering what had happened to this bug and was about to ask, just as I
saw this. It applies cleanly to 4.1 and does the trick - just tested with
util-linux-2.16.2. My / now properly shows lazytime after remount, so
Thank You and:

Tested-By: Holger Hoffstaette <holger.hoffstaette@googlemail.com>

-h
