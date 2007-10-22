From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] Split fs/Kconfig: ext[234]
Date: Mon, 22 Oct 2007 15:06:51 -0700
Message-ID: <20071022150651.922f9fdb.akpm@linux-foundation.org>
References: <20071006081508.GA7924@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20071006081508.GA7924@martell.zuzino.mipt.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 6 Oct 2007 12:15:08 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  fs/Kconfig      |  191 ----------------------------------------------
>  fs/ext2/Kconfig |   55 +++++++++++++
>  fs/ext3/Kconfig |   67 ++++++++++++++++
>  fs/ext4/Kconfig |   65 +++++++++++++++
>  4 files changed, 190 insertions(+), 188 deletions(-)

A reasonable thing to do, but poorly timed.  I'd prefer not to carry a
patch like this through two months of development, please.

Late in the -rc timeframe would be a better time.
