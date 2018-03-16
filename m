From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: mmc: block: bonnie++ runs with errors on arc/hsdk board
Date: Fri, 16 Mar 2018 09:20:35 +0200
Message-ID: <94e11cab-8c46-4780-1413-f08e8f848342@intel.com>
References: <1520942674.10285.8.camel@synopsys.com>
 <486fe92e-9b53-53a4-f98d-129a97032470@intel.com>
 <1520956602.10285.10.camel@synopsys.com>
 <1521030769.10285.16.camel@synopsys.com>
 <83de0f90-0919-f449-b432-494b9bf524a1@intel.com>
 <345e9053-9251-ad27-d05b-ec80b69ee235@synopsys.com>
 <1521134509.6358.1.camel@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy.Didin@synopsys.com" <Evgeniy.Didin@synopsys.com>,
 "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "tytso@mit.edu" <tytso@mit.edu>,
 "vincent.weaver@maine.edu" <vincent.weaver@maine.edu>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
 "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
 "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
 "linux-snps-arc@lists.infradead.org" <linux-snps-arc@lists.infradead.org>,
 "Eugeniy.Paltsev@synopsys.com" <Eugeniy.Paltsev@synopsys.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
 Vineet Gupta <Vineet.Gupta1@synopsys.com>
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <1521134509.6358.1.camel@synopsys.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

On 15/03/18 19:21, Alexey Brodkin wrote:
> Hi Vineet,
> 
> On Thu, 2018-03-15 at 09:38 -0700, Vineet Gupta wrote:
>> On 03/15/2018 02:27 AM, Adrian Hunter wrote:
>>> Please try:
>>>
>>> 	perf record -a -e mmc:* -- bonnie++ -u root -r 256 -s 512 -x 1 -d /mnt
>>>
>>> and share the resulting perf.data file when you are able
>>> to reproduce the hung task message.
>>>
>>> You may want to add this patch first:
>>>
>>> 	https://marc.info/?l=linux-mmc&m=152110580324200
>>
>> While this SoC has perf counters, Unfortunately the overflow interrupts are not 
>> wired up. We can do perf stats but not sampling.
> 
> I guess here Adrian was asking for pure software MMC-related events which are
> orthogonal to CPU's perf interrupts.
> 
> Adrian?

Yes, these are mmc tracepoints which are software events.  The file is full
of them, so it certainly worked.
