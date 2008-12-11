From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH] ext2: ensure link targets are NULL-terminated
Date: Thu, 11 Dec 2008 20:25:03 +0000
Message-ID: <e9e943910812111225o700afd2crc72e3aab4053fa72@mail.gmail.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-2-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-3-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-4-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-5-git-send-email-duaneg@dghda.com>
	 <20081211192158.GE26095@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Boaz Harrosh" <bharrosh@panasas.com>, linux-ext4@vger.kernel.org
To: "Matthew Wilcox" <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081211192158.GE26095@parisc-linux.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2008/12/11 Matthew Wilcox <matthew@wil.cx>:
> On Thu, Dec 11, 2008 at 07:16:28PM +0000, Duane Griffin wrote:
>> Ensure link targets are NULL-terminated, even if corrupted on-disk.
>
> FWIW, that's spelled 'NUL' -- NULL is a pointer value, NUL is an ASCII
> code.

Good point, thanks. I'll try to remember for the future!

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
